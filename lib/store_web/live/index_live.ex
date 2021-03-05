defmodule Elementary.StoreWeb.IndexLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  alias Elementary.Store.Catalog

  @impl true
  def mount(_params, %{"locale" => locale}, socket) do
    Gettext.put_locale(Elementary.StoreWeb.Gettext, locale)

    new_socket =
      socket
      |> assign(:products, Catalog.get_products())
      |> assign(:page_title, "Store")
      |> assign(:page_image, nil)

    {:ok, new_socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.IndexView.render("index.html", assigns)
  end
end
