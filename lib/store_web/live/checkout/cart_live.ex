defmodule Elementary.StoreWeb.Checkout.CartLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  @impl true
  def mount(_params, %{"session_id" => session_id, "cart" => cart}, socket) do
    Elementary.StoreWeb.Endpoint.subscribe(session_id)

    {:ok, assign(socket, :cart, cart)}
  end

  @impl true
  def handle_info({:cart_update, cart}, socket) do
    {:noreply, assign(socket, :cart, cart)}
  end

  @impl true
  def handle_info(_event, socket), do: {:noreply, socket}

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.CheckoutView.render("cart.html", assigns)
  end
end
