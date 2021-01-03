defmodule Elementary.Store.Catalog do
  @moduledoc """
  Entry point to handle the catalog stuffs
  """

  alias Elementary.Store.Catalog.{Product, Variant}

  def get_products() do
    Printful.Store.products()
    |> Enum.map(&Map.get(&1, :id))
    |> Enum.map(&get_product/1)
  end

  def get_product(product_id) do
    product = Printful.Store.product(product_id)

    variants =
      product
      |> Map.get(:sync_variants)
      |> Enum.map(&Map.get(&1, :id))
      |> Enum.map(&get_variant/1)

    Product.from_printful(product, variants)
  end

  def get_variants(product_id) do
    Printful.Store.product(product_id)
    |> Map.get(:sync_variants)
    |> Enum.map(&Map.get(&1, :id))
    |> Enum.map(&get_variant/1)
  end

  def get_variant(variant_id) do
    store = Printful.Store.variant(variant_id)
    catalog = Printful.Catalog.variant(store.product.variant_id)

    Variant.from_printful(store, catalog)
  end
end
