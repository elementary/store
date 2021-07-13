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
    printful_response =
      Printful.Order.create(%{
        shipping: order.shipping_rate.id,
        recipient: printful_recipient(order),
        items: Enum.map(order.items, &printful_line_item/1),
        retail_costs: %{
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
      automatic_tax: %{
        enabled: true
      },
      mode: "payment",
      payment_intent_data: %{
        description: "elementary Store",
        metadata: %{
          source: "elementary/store#v1",
          printful_id: printful_response.id,
          locale: Gettext.get_locale()
        }
      },
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

  # credo:disable-for-next-line Credo.Check.Refactor.CyclomaticComplexity
  defp stripe_tax_code(%{type: type}) do
    cond do
      String.contains?(type, "t-shirt") -> "txcd_30011000"
      String.contains?(type, "jacket") -> "txcd_30011000"
      String.contains?(type, "sweatshirt") -> "txcd_30011000"
      String.contains?(type, "hoodie") -> "txcd_30011000"
      String.contains?(type, "laptop sleeve") -> "txcd_30060001"
      true -> "txcd_99999999"
    end
  end

  defp stripe_line_item({variant_id, quantity}) do
    variant = Catalog.get_variant(variant_id)
    product = Catalog.get_product(variant.product_id)

    %{
      price_data: %{
        currency: "USD",
        unit_amount: round(variant.price * 100),
        tax_behavior: "exclusive",
        product_data: %{
          name: variant.name,
          images: [variant.preview_url],
          tax_code: stripe_tax_code(product)
        }
      },
      quantity: quantity
    }
  end

  defp stripe_extra_lines(%{retail_costs: %{shipping: shipping}}) when not is_nil(shipping) do
    {amount, _} = Float.parse(shipping)

    [
      %{
        price_data: %{
          currency: "USD",
          unit_amount: round(amount * 100),
          tax_behavior: "exclusive",
          product_data: %{
            name: "Shipping",
            tax_code: "txcd_92010001"
          }
        },
        quantity: 1
      }
    ]
  end

  defp stripe_extra_lines(_printful_response), do: []

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
