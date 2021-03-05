defmodule Elementary.StoreWeb.ProductLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  alias Elementary.Store.Catalog

  @impl true
  def mount(%{"product" => product_id, "variant" => variant_id}, %{"locale" => locale}, socket) do
    Gettext.put_locale(Elementary.StoreWeb.Gettext, locale)

    new_socket = assign_data(socket, product_id, variant_id)
    {:ok, new_socket}
  end

  @impl true
  def mount(%{"product" => product_id}, %{"locale" => locale}, socket) do
    Gettext.put_locale(Elementary.StoreWeb.Gettext, locale)

    new_socket = assign_data(socket, product_id, nil)
    {:ok, new_socket}
  end

  @impl true
  def handle_params(%{"product" => product_id, "variant" => variant_id}, _url, socket) do
    new_socket = assign_data(socket, product_id, variant_id)
    {:noreply, new_socket}
  end

  @impl true
  def handle_params(%{"variant" => variant_id}, _url, socket) do
    new_socket = assign_data(socket, socket.assign.product.id, variant_id)
    {:noreply, new_socket}
  end

  @impl true
  def handle_params(%{"product" => product_id}, _url, socket) do
    new_socket = assign_data(socket, product_id, nil)
    {:noreply, new_socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.ProductView.render("index.html", assigns)
  end

  defp assign_data(socket, product_id, variant_id) do
    product = Catalog.get_product(product_id)
    variants = Catalog.get_variants(product.id)

    selected_variant = find_variant(variant_id, variants)

    new_socket =
      socket
      |> assign(:product, product)
      |> assign(:variants, variants)
      |> assign(:variant, selected_variant)
      |> assign(:page_title, selected_variant.name)
      |> assign(:page_image, selected_variant.preview_url)

    new_socket
  end

  defp find_variant(nil, variants), do: hd(variants)
  defp find_variant(variant, _variants) when is_map(variant), do: variant

  defp find_variant(variant, variants) when is_binary(variant) do
    variants
    |> Enum.find(&(to_string(&1.id) === variant))
    |> find_variant(variants)
  end

  defp find_variant(_, variants), do: find_variant(nil, variants)
end
