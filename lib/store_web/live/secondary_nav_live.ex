defmodule Elementary.StoreWeb.SecondaryNavLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  @impl true
  def mount(_params, %{"session_id" => session_id, "cart" => cart}, socket) do
    Elementary.StoreWeb.Endpoint.subscribe(session_id)

    categories =
      Elementary.Store.Catalog.get_products()
      |> Enum.map(& &1.category)
      |> Enum.uniq()
      |> Enum.sort()

    {:ok,
     socket
     |> assign(:categories, categories)
     |> assign(:cart, cart)}
  end

  @impl true
  def handle_info({:cart_update, cart}, socket) do
    {:noreply, assign(socket, :cart, cart)}
  end

  @impl true
  def handle_info(_event, socket), do: {:noreply, socket}

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.LayoutView.render("secondary-nav.html", assigns)
  end
end
