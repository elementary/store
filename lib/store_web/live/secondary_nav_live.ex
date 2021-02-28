defmodule Elementary.StoreWeb.SecondaryNavLive do
  @moduledoc false

  use Elementary.StoreWeb, :view_helpers

  use Phoenix.LiveView,
    container: {:div, class: "nav-sticky"}

  @impl true
  def mount(_params, %{"locale" => locale, "cart" => cart}, socket) do
    Gettext.put_locale(Elementary.StoreWeb.Gettext, locale)
    Elementary.StoreWeb.Endpoint.subscribe(cart.id)

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
    Elementary.StoreWeb.LayoutView.render("secondary-nav.html", assigns)
  end
end
