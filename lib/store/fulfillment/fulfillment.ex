defmodule Elementary.Store.Fulfillment do
  @moduledoc """
  Handles the payment session creating for Stripe, and the order creation from
  Printful.
  """

  alias Elementary.Store.{Catalog, Shipping}
  alias __MODULE__
  alias Elementary.StoreWeb.Router.Helpers, as: Routes

  @payment_types ["card"]

  def create_stripe_session(%Fulfillment.Order{} = order) do
    Stripe.Session.create(%{
      cancel_url: Routes.checkout_url(Elementary.StoreWeb.Endpoint, :index),
      success_url: Routes.result_url(Elementary.StoreWeb.Endpoint, :success),
      payment_method_types: @payment_types,
      customer_email: order.email,
      line_items: Enum.map(order.items, &stripe_item/1) ++ [shipping_line(order)],
      locale: order.locale,
      mode: "payment",
      metadata: %{
        source: "elementary/store#v1"
      }
    })
  end

  defp stripe_item({variant_id, quantity}) do
    variant = Catalog.get_variant(variant_id)

    %{
      amount: round(variant.price * 100),
      currency: "USD",
      name: variant.name,
      quantity: quantity,
      images: [variant.preview_url]
    }
  end

  defp shipping_line(order) do
    %{
      amount: round(order.shipping_rate.price * 100),
      currency: "USD",
      name: order.shipping_rate.name,
      description: order.shipping_rate.estimate,
      quantity: 1
    }
  end
end
