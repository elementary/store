defmodule Elementary.StoreWeb.Checkout.AddressLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  alias Elementary.Store.PubSub, as: StorePubSub
  alias Elementary.Store.Shipping
  alias Phoenix.PubSub

  @default_address %{"country" => "US"}

  @impl true
  def mount(_params, %{"session_id" => session_id}, socket) do
    new_socket =
      socket
      |> assign(:session_id, session_id)
      |> assign(:countries, Shipping.get_countries())
      |> assign(:states, Shipping.get_states(grab_address(@default_address).country))
      |> assign(:address, grab_address(@default_address))

    {:ok, new_socket}
  end

  @impl true
  def handle_event("change", _, socket) do
    PubSub.broadcast(StorePubSub, socket.assigns.session_id, {:address_update, nil})
    {:noreply, socket}
  end

  @impl true
  def handle_event("submit", %{"address" => address}, socket) do
    updated_address = grab_address(address)
    PubSub.broadcast(StorePubSub, socket.assigns.session_id, {:address_update, updated_address})
    {:noreply, assign(socket, :address, updated_address)}
  end

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.CheckoutView.render("address.html", assigns)
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
