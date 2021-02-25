defmodule Elementary.Store.Email do
  @moduledoc """
  This handles building and creating emails to be sent by the
  `Elementary.Store.Mailer`.
  """

  use Bamboo.Phoenix, view: Elementary.StoreWeb.EmailView

  alias Elementary.StoreWeb.LayoutView

  import Elementary.StoreWeb.Gettext

  def order_created(printful_order) do
    new_email()
    |> to({printful_order.recipient.name, printful_order.recipient.email})
    |> subject(dgettext("email", "Your order has been received!"))
    |> from("payments@elementary.io")
    |> put_text_layout({LayoutView, "email.text"})
    |> put_html_layout({LayoutView, "email.html"})
    |> assign(:title, dgettext("email", "Your order has been received!"))
    |> assign(:order, printful_order)
    |> render(:order_created)
  end

  def package_shipped(printful_order, printful_shipment) do
    new_email()
    |> to({printful_order.recipient.name, printful_order.recipient.email})
    |> subject(dgettext("email", "Your order has been shipped!"))
    |> from("payments@elementary.io")
    |> put_text_layout({LayoutView, "email.text"})
    |> put_html_layout({LayoutView, "email.html"})
    |> assign(:title, dgettext("email", "Your package shipped!"))
    |> assign(:order, printful_order)
    |> assign(:shipment, printful_shipment)
    |> render(:package_shipped)
  end
end
