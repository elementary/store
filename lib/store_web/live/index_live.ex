defmodule Elementary.StoreWeb.IndexLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  alias Elementary.Store.Catalog

  @impl true
  def mount(_params, _session, socket) do
    new_socket =
      socket
      |> assign(:products, Catalog.get_products())
      |> assign(:page_title, "Store")

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
