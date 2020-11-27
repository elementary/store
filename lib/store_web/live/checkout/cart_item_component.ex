defmodule Elementary.StoreWeb.Checkout.CartItemComponent do
  @moduledoc false

  use Elementary.StoreWeb, :live_component

  alias Elementary.Store.Catalog

  def update(%{variant_id: variant_id, quantity: quantity}, socket) do
    variant = Catalog.get_variant(variant_id)

    updated_socket =
      socket
      |> assign(:variant, variant)
      |> assign(:quantity, quantity)

    {:ok, updated_socket}
  end

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.CheckoutView.render("cart_item.html", assigns)
  end
end
