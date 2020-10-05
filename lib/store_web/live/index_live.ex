defmodule Elementary.StoreWeb.IndexLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  alias Elementary.Store.Printful

  @impl true
  def mount(_params, _session, socket) do
    case Printful.products() do
      {:ok, products} ->
        new_socket =
          socket
          |> assign(:products, products)
          |> assign(:page_title, "Store")

        {:ok, new_socket}

      res ->
        res
    end
  end

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.IndexView.render("index.html", assigns)
  end
end
