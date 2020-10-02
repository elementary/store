defmodule Elementary.StoreWeb.IndexLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    case Elementary.Store.Printful.products() do
      {:ok, products} ->
        {:ok, assign(socket, products: products)}

      {:error, status_code} ->
        new_socket =
          socket
          |> put_flash(:error, "Unable to connect to our Store")
          |> assign(products: [])

        {:ok, new_socket}
    end
  end

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.IndexView.render("index.html", Map.put(assigns, :conn, assigns.socket))
  end
end
