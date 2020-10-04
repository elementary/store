defmodule Elementary.StoreWeb.ProductLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  alias Elementary.Store.Printful

  @impl true
  def mount(%{"product" => product} = params, _session, socket) do
    case Printful.product(product) do
      {:ok, %{product: product, variants: variants}} ->
        {:ok,
         assign(socket,
           product: product,
           variants: variants,
           variant: variant(params["variant"], variants)
         )}

      res ->
        res
    end
  end

  @impl true
  def handle_params(%{"variant" => variant_id}, _url, socket) do
    {:noreply, assign(socket, variant: variant(variant_id, socket.assigns.variants))}
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

  defp variant(nil, variants), do: hd(variants)
  defp variant(variant, variants) when is_map(variant), do: variant

  defp variant(variant, variants) when is_binary(variant) do
    variants
    |> Enum.find(&(to_string(&1.id) === variant))
    |> variant(variants)
  end

  defp variant(_, variants), do: variant(nil, variants)

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.ProductView.render("index.html", assigns)
  end
end
