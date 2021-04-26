defmodule Elementary.Store.Fulfillment do
  @moduledoc """
  Handles the payment session creating for Stripe, and the order creation from
  Printful.
  """

  alias Elementary.Store.{Catalog, Email, Mailer, Shipping}
  alias Elementary.StoreWeb.Router.Helpers, as: Routes
  alias __MODULE__

  require Logger

  @stripe_payment_types ["card"]

  def create_order(%Fulfillment.Order{} = order) do
    tax_price =
      %{recipient: printful_recipient(order)}
      |> Printful.Tax.get()
      |> calculate_taxes(order)

    printful_response =
      Printful.Order.create(%{
        shipping: order.shipping_rate.id,
        recipient: printful_recipient(order),
        items: Enum.map(order.items, &printful_line_item/1),
        retail_costs: %{
          tax: tax_price,
          shipping: order.shipping_rate.price
        }
      })

    Stripe.Session.create(%{
      cancel_url: Routes.checkout_url(Elementary.StoreWeb.Endpoint, :index),
      success_url: Routes.result_url(Elementary.StoreWeb.Endpoint, :success),
      payment_method_types: @stripe_payment_types,
      allow_promotion_codes: true,
      customer_email: order.email,
      line_items:
        Enum.map(order.items, &stripe_line_item/1) ++ stripe_extra_lines(printful_response),
      locale: order.locale,
      mode: "payment",
      metadata: %{
        source: "elementary/store#v1",
        printful_id: printful_response.id,
        locale: Gettext.get_locale()
      }
    })
  end

  defp printful_recipient(order) do
    %{
      name: order.address.name,
      address1: order.address.line1,
      address2: order.address.line2,
      city: order.address.city,
      state_code: order.address.state,
      country_code: order.address.country,
      zip: order.address.postal,
      email: order.email,
      phone: order.phone_number
    }
  end

  defp calculate_taxes(%{rate: tax_rate} = tax, order) do
    item_total =
      order.items
      |> Enum.map(fn {variant_id, quantity} -> {Catalog.get_variant(variant_id), quantity} end)
      |> Enum.map(fn {variant, quantity} -> variant.price * quantity end)
      |> Enum.reduce(0, fn a, b -> a + b end)

    taxable_amount =
      if tax.shipping_taxable do
        item_total + order.shipping_rate.price
      else
        item_total
      end

    Float.ceil(taxable_amount * tax_rate, 2)
  end

  defp calculate_taxes(_, _order), do: 0

  defp printful_line_item({variant_id, quantity}) do
    variant = Catalog.get_variant(variant_id)

    %{
      sync_variant_id: variant.id,
      files: variant.printful_files,
      quantity: quantity,
      retail_price: variant.price,
      name: variant.name
    }
  end

  defp stripe_line_item({variant_id, quantity}) do
    variant = Catalog.get_variant(variant_id)

    %{
      amount: round(variant.price * 100),
      currency: "USD",
      name: variant.name,
      quantity: quantity,
      images: [variant.preview_url]
    }
  end

  defp stripe_extra_lines(printful_response) do
    printful_response.retail_costs
    |> Map.take([:shipping, :tax, :vat])
    |> Enum.reject(fn {_k, v} -> is_nil(v) end)
    |> Enum.map(fn {name, value} ->
      {amount, _} = Float.parse(value)

      %{
        amount: round(amount * 100),
        currency: "USD",
        name: String.capitalize(to_string(name)),
        quantity: 1
      }
    end)
  end

  def fulfill_order(%Stripe.Session{livemode: livemode, metadata: %{"printful_id" => printful_id}}) do
    printful_id
    |> Printful.Order.get()
    |> Email.order_created()
    |> Mailer.deliver_later()

    if livemode do
      fulfill_order(printful_id)
    else
      Logger.info("Not confirming order #{printful_id} due to stripe testmode payment")
    end
  end

  def fulfill_order(printful_id) do
    Printful.Order.confirm(printful_id)
  end
end
