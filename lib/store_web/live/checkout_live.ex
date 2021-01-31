defmodule Elementary.StoreWeb.CheckoutLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  alias Elementary.Store.PubSub, as: StorePubSub
  alias Elementary.Store.Shipping
  alias Phoenix.PubSub

  @default_address %{"country" => "US"}

  @impl true
  def mount(_params, %{"session_id" => session_id, "cart" => cart}, socket) do
    Elementary.StoreWeb.Endpoint.subscribe(session_id)

    new_socket =
      socket
      |> assign(:page_title, "Cart")
      |> assign(:session_id, session_id)
      |> assign(:error, nil)
      |> assign(:cart, cart)
      |> assign(:countries, Shipping.get_countries())
      |> assign(:states, Shipping.get_states(grab_address(@default_address).country))
      |> assign(:address, grab_address(@default_address))
      |> assign(:shipping_rates, [])
      |> assign(:shipping_rate, nil)

    {:ok, new_socket}
  end

  @impl true
  def handle_event("change", %{"address" => address}, socket) do
    updated_address = grab_address(address)

    new_socket =
      socket
      |> assign(:error, nil)
      |> assign(:states, Shipping.get_states(updated_address.country))
      |> assign(:address, updated_address)
      |> assign(:shipping_rates, [])
      |> assign(:shipping_rate, nil)

    {:noreply, new_socket}
  end

  @impl true
  def handle_event("change", %{"shipping" => %{"id" => shipping_rate_id}}, socket) do
    shipping_rate =
      Enum.find(socket.assigns.shipping_rates, fn rate ->
        rate.id == shipping_rate_id
      end)

    {:noreply, assign(socket, :shipping_rate, shipping_rate)}
  end

  @impl true
  def handle_event("submit", %{"address" => address}, socket) do
    updated_address = grab_address(address)

    shipping_rates = Shipping.get_rates(updated_address, socket.assigns.cart)

    new_socket =
      socket
      |> assign(:error, nil)
      |> assign(:address, updated_address)
      |> assign(:shipping_rates, shipping_rates)
      |> assign(:shipping_rate, hd(shipping_rates))

    {:noreply, new_socket}
  rescue
    e in Printful.ApiError -> {:noreply, assign(socket, :error, e.message)}
  end

  @impl true
  def handle_event("submit", %{"shipping" => %{"id" => shipping_rate_id}}, socket) do
    shipping_rate =
      Enum.find(socket.assigns.shipping_rates, fn rate ->
        rate.id == shipping_rate_id
      end)

    new_socket =
      socket
      |> assign(:error, nil)
      |> assign(:shipping_rate, shipping_rate)

    {:noreply, new_socket}
  end

  @impl true
  def handle_event("submit", _params, socket) do
    {:noreply, assign(socket, :error, "Please fill out the form")}
  end

  @impl true
  def handle_info({:cart_update, cart}, socket) do
    new_socket =
      socket
      |> assign(:cart, cart)
      |> assign(:shipping_rates, [])
      |> assign(:shipping_rate, nil)

    {:noreply, new_socket}
  end

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.CheckoutView.render("index.html", assigns)
  end

  defp grab_address(params) do
    %{
      name: Map.get(params, "name", ""),
      line1: Map.get(params, "line1", ""),
      line2: Map.get(params, "line2", ""),
      city: Map.get(params, "city", ""),
      state: Map.get(params, "state", ""),
      country: Map.get(params, "country", ""),
      postal: Map.get(params, "postal", ""),
      email: Map.get(params, "email", ""),
      phone: Map.get(params, "phone", "")
    }
  end
end
