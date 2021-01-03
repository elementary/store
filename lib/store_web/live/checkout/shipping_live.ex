defmodule Elementary.StoreWeb.Checkout.ShippingLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  alias Elementary.Store.PubSub, as: StorePubSub
  alias Elementary.Store.Shipping
  alias Phoenix.PubSub

  @impl true
  def mount(_params, %{"session_id" => session_id, "cart" => cart}, socket) do
    Elementary.StoreWeb.Endpoint.subscribe(session_id)

    new_socket =
      socket
      |> assign(:address, nil)
      |> assign(:cart, cart)
      |> assign(:error, nil)
      |> assign(:rates, nil)
      |> assign(:rate_id, nil)

    {:ok, new_socket}
  end

  @impl true
  def handle_event("change", %{"shipping" => %{"id" => rate_id}}, socket) do
    {:noreply, assign(socket, :rate_id, rate_id)}
  end

  @impl true
  def handle_event("submit", %{"shipping" => %{"id" => rate_id}}, socket) do
    {:noreply, assign(socket, :rate_id, rate_id)}
  end

  @impl true
  def handle_info({:address_update, nil}, socket) do
    new_socket =
      socket
      |> assign(:error, nil)
      |> assign(:rates, nil)

    {:noreply, new_socket}
  end

  @impl true
  def handle_info({:address_update, address}, socket) do
    new_socket =
      socket
      |> assign(:address, address)
      |> assign(:error, nil)

    set_rates(new_socket)
  end

  @impl true
  def handle_info({:cart_update, cart}, socket) do
    new_socket = assign(socket, :cart, cart)

    if socket.assigns.address != nil do
      set_rates(new_socket)
    else
      {:noreply, new_socket}
    end
  end

  @impl true
  def handle_info(_event, socket), do: {:noreply, socket}

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.CheckoutView.render("shipping.html", assigns)
  end

  defp set_rates(%{assigns: %{address: address, cart: cart}} = socket) do
    rates = Shipping.get_rates(address, cart)
    {:noreply, assign(socket, :rates, rates)}
  rescue
    e in Elementary.Printful.ApiError ->
      {:noreply, assign(socket, :error, e.message)}
  end
end
