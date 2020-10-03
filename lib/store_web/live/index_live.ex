defmodule Elementary.StoreWeb.IndexLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  alias Elementary.Store.Printful

  @impl true
  def mount(_params, _session, socket) do
    case Printful.products() do
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
  def handle_event("go_to_product", %{"product" => product_id}, socket) do
    new_socket = push_redirect(socket, to: Routes.product_path(socket, :index, product_id))

    {:noreply, new_socket}
  end

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.IndexView.render("index.html", assigns)
  end
end
