defmodule Elementary.Store.Email do
  @moduledoc """
  This handles building and creating emails to be sent by the
  `Elementary.Store.Mailer`.
  """

  use Phoenix.Swoosh,
    view: Elementary.StoreWeb.EmailView,
    layout: {Elementary.StoreWeb.LayoutView, :email}

  import Elementary.StoreWeb.Gettext

  def order_created(printful_order) do
    new()
    |> to({printful_order.recipient.name, printful_order.recipient.email})
    |> subject(dgettext("email", "Your order has been received!"))
    |> from("payments@elementary.io")
    |> assign(:title, dgettext("email", "Your order has been received!"))
    |> assign(:order, printful_order)
    |> render_body(:order_created)
  end

  def package_shipped(printful_order, printful_shipment) do
    new()
    |> to({printful_order.recipient.name, printful_order.recipient.email})
    |> subject(dgettext("email", "Your order has been shipped!"))
    |> from("payments@elementary.io")
    |> assign(:title, dgettext("email", "Your package shipped!"))
    |> assign(:order, printful_order)
    |> assign(:shipment, printful_shipment)
    |> render_body(:package_shipped)
  end
end
