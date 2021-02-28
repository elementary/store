defmodule Elementary.StoreWeb.CheckoutLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  alias Elementary.Store.PubSub, as: StorePubSub
  alias Elementary.Store.{Checkout, Fulfillment, Shipping}
  alias Phoenix.PubSub

  @impl true
  def mount(_params, %{"locale" => locale, "cart" => cart}, socket) do
    Gettext.put_locale(Elementary.StoreWeb.Gettext, locale)
    Elementary.StoreWeb.Endpoint.subscribe(cart.id)

    changeset = Checkout.change_cart(cart)

    new_socket =
      socket
      |> assign(:page_title, "Cart")
      |> assign(:cart, cart)
      |> assign(:changeset, changeset)
      |> assign(:countries, Shipping.get_countries())
      |> assign(:states, Shipping.get_states(cart.address.country))
      |> assign(:shipping_rates, [])

    {:ok, new_socket}
  end

  @impl true
  def handle_event("change", %{"address" => address}, socket) do
    case Checkout.update(socket.assigns.cart, address: address, shipping_rate: nil) do
      {:ok, cart} ->
        changeset = Checkout.change_cart(cart)

        socket =
          socket
          |> assign(:cart, cart)
          |> assign(:changeset, changeset)
          |> assign(:states, Shipping.get_states(cart.address.country))
          |> assign(:shipping_rates, [])

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(:changeset, changeset)
          |> assign(:shipping_rates, [])

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("change", %{"shipping" => %{"id" => shipping_rate_id}}, socket) do
    shipping_rate = Enum.find(socket.assigns.shipping_rates, fn rate ->
      rate.id == shipping_rate_id
    end)

    cart = Checkout.update_cart(socket.assigns.cart, shipping_rate: shipping_rate)
    changeset = Checkout.change_cart(cart)

    socket =
      socket
      |> assign(:cart, cart)
      |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_event("submit", %{"address" => address}, socket) do
    case Checkout.update_cart(socket.assigns.cart, address: address) do
      {:ok, cart} ->
        shipping_rates = Shipping.get_rates(cart)
        changeset = Checkout.change_cart(cart)

        socket =
          socket
          |> assign(:cart, cart)
          |> assign(:changeset, changeset)
          |> assign(:shipping_rates, shipping_rates)

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(:changeset, changeset)
          |> assign(:shipping_rates, [])

        {:noreply, socket}
    end
  rescue
    e in Printful.ApiError ->
      changeset =
        socket.assigns.cart
        |> Checkout.Cart.changeset()
        |> Ecto.Changeset.add_error(:shipping_rates, e.message)

      {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("submit", %{"shipping" => %{"id" => shipping_rate_id}}, socket) do
    shipping_rate = Enum.find(socket.assigns.shipping_rates, fn rate ->
      rate.id == shipping_rate_id
    end)

    cart = Checkout.update_cart(socket.assigns.cart, shipping_rate: shipping_rate)
    changeset = Checkout.change_cart(cart)

    stripe_res =
      cart
      |> Fulfillment.Order.create()
      |> Fulfillment.create_order()

    socket =
      socket
      |> assign(:cart, cart)
      |> assign(:changeset, changeset)
      |> push_event("sessionRedirect", %{session_id: stripe_session.id})

    {:noreply, socket}
  end

  @impl true
  def handle_event("submit", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:cart_update, cart}, socket) do
    changeset = Checkout.change_cart(cart)

    new_socket =
      socket
      |> assign(:cart, cart)
      |> assign(:changeset, changeset)
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
end
