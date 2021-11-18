defmodule Elementary.Store.Fulfillment do
  @moduledoc """
  Handles the payment session creating for Stripe, and the order creation from
  Printful.
  """

  alias Elementary.Store.{Catalog, Email, Mailer, Shipping}
  alias Elementary.StoreWeb.Router.Helpers, as: Routes
  alias __MODULE__

  require Logger

  @stripe_store_source "elementary/store#v1"
  @stripe_payment_types ["card"]

  def create_order(%Fulfillment.Order{} = order) do
    shipping_rates = Shipping.get_rates(order.address, order.items) |> IO.inspect(label: "shipping rates")

    Stripe.Session.create(%{
      cancel_url: Routes.checkout_url(Elementary.StoreWeb.Endpoint, :index),
      success_url: Routes.result_url(Elementary.StoreWeb.Endpoint, :success),
      payment_method_types: @stripe_payment_types,
      allow_promotion_codes: true,
      customer_email: order.email,
      line_items: Enum.map(order.items, &stripe_line_item/1),
      locale: order.locale,
      automatic_tax: %{
        enabled: true
      },
      mode: "payment",
      payment_intent_data: %{
        description: "elementary Store",
        metadata: %{
          source: @stripe_store_source,
          locale: Gettext.get_locale()
        }
      },
      metadata: %{
        source: @stripe_store_source,
        locale: Gettext.get_locale(),
        printful_cart: order.items |> Enum.into(%{}) |> Jason.encode!()
      },
      shipping_address_collection: %{
        allowed_countries: ["US", "DE", "AU", "NZ", "GB"]
      },
      shipping_options: Enum.map(shipping_rates, &stripe_shipping_item/1)
    } |> IO.inspect(label: "stripe object"))
  rescue
    e in Printful.ApiError -> {:error, e.message}
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

  defp stripe_shipping_item(%Elementary.Store.Shipping.Rate{} = rate) do
    %{
      shipping_rate_data: %{
        display_name: rate.name,
        type: "fixed_amount",
        fixed_amount: %{
          amount: round(rate.price * 100),
          currency: "USD"
        },
        metadata: %{
          printful_id: rate.id
        },
        tax_behavior: "inclusive"
      }
    }
  end

  def fulfill_order(%Stripe.Session{metadata: %{"source" => @stripe_store_source}} = stripe_charge) do
    IO.inspect(stripe_charge, label: "charge")

    # printful_id
    # |> Printful.Order.get()
    # |> Email.order_created()
    # |> Mailer.deliver_later()

    # fulfill_order(printful_id)
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
end
