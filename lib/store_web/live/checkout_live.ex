defmodule Elementary.StoreWeb.CheckoutLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  alias Elementary.Store.PubSub, as: StorePubSub
  alias Elementary.Store.{Fulfillment, Shipping}
  alias Phoenix.PubSub

  @impl true
  def mount(_params, %{"session_id" => session_id, "cart" => cart, "address" => address}, socket) do
    Elementary.StoreWeb.Endpoint.subscribe(session_id)

    new_socket =
      socket
      |> assign(:page_title, "Cart")
      |> assign(:session_id, session_id)
      |> assign(:error, nil)
      |> assign(:cart, cart)
      |> assign(:countries, Shipping.get_countries())
      |> assign(:states, Shipping.get_states(grab_address(address).country))
      |> assign(:address, grab_address(address))
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

    stripe_res =
      socket.assigns.cart
      |> Fulfillment.Order.create(socket.assigns.address, shipping_rate)
      |> Fulfillment.create_stripe_session()

    case stripe_res do
      {:ok, stripe_session} ->
        new_socket =
          socket
          |> assign(:error, nil)
          |> assign(:shipping_rate, shipping_rate)
          |> push_event("sessionRedirect", %{session_id: stripe_session.id})

        {:noreply, new_socket}

      {:error, %{message: message}} ->
        {:noreply, assign(socket, :error, message)}
    end
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
  def handle_info(_update, socket) do
    {:noreply, socket}
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
