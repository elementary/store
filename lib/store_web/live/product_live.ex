defmodule Elementary.StoreWeb.ProductLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  alias Elementary.Store.Printful

  @impl true
  def mount(%{"product" => product} = params, _session, socket) do
    case Printful.product(product) do
      {:ok, product} ->
        {:ok,
         assign(socket,
           product: product,
           variant: variant(params["variant"], product)
         )}

      res ->
        res
    end
  end

  @impl true
  def handle_params(%{"variant" => variant_id}, _url, socket) do
    {:noreply, assign(socket, variant: variant(variant_id, socket.assigns.product))}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("go_to_variant", %{"variant" => variant_id}, socket) do
    {:noreply,
     push_patch(socket,
       to: Routes.product_path(socket, :index, socket.assigns.product.id, variant_id),
       replace: true
     )}
  end

  defp variant(nil, product), do: hd(product.variants)
  defp variant(variant, product) when is_map(variant), do: variant

  defp variant(variant, product) when is_binary(variant) do
    product.variants
    |> Enum.find(&(to_string(&1.id) === variant))
    |> variant(product)
  end

  defp variant(_, product), do: variant(nil, product)

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.ProductView.render("index.html", assigns)
  end
end
