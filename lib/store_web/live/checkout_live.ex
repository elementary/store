defmodule Elementary.StoreWeb.CheckoutLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  alias Elementary.Store.PubSub, as: StorePubSub
  alias Elementary.Store.{Fulfillment, Shipping}
  alias Phoenix.PubSub

  @impl true
  def mount(
        _params,
        %{"locale" => locale, "session_id" => session_id, "cart" => cart, "address" => address},
        socket
      ) do
    Gettext.put_locale(Elementary.StoreWeb.Gettext, locale)
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

    {:ok, new_socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("change", %{"address" => address}, socket) do
    updated_address = grab_address(address)

    new_socket =
      socket
      |> assign(:error, nil)
      |> assign(:states, Shipping.get_states(updated_address.country))
      |> assign(:address, updated_address)

    {:noreply, new_socket}
  end

  @impl true
  def handle_event("change", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("submit", %{"address" => address}, socket) do
    updated_address = grab_address(address)

    stripe_res =
      socket.assigns.cart
      |> Fulfillment.Order.create(updated_address)
      |> Fulfillment.create_order()

    case stripe_res do
      {:ok, stripe_session} ->
        new_socket =
          socket
          |> assign(:error, nil)
          |> assign(:address, updated_address)
          |> push_event("sessionRedirect", %{session_id: stripe_session.id})

        {:noreply, new_socket}

      {:error, %{message: message}} ->
        {:noreply, assign(socket, :error, message)}

      {:error, message} ->
        {:noreply, assign(socket, :error, message)}
    end
  end

  @impl true
  def handle_event("submit", _params, socket) do
    {:noreply, assign(socket, :error, "Please fill out the form")}
  end

  @impl true
  def handle_info({:cart_update, cart}, socket) do
    {:noreply, assign(socket, :cart, cart)}
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
      phone_number: Map.get(params, "phone_number", "")
    }
  end
end
