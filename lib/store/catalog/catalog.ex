defmodule Elementary.Store.Catalog do
  @moduledoc """
  Entry point to handle the catalog stuffs
  """

  alias Elementary.Store.Catalog.{Product, Variant}

  def get_products() do
    products =
      Printful.Store.products()
      |> Enum.map(&Map.get(&1, :id))
      |> Enum.map(&Printful.Store.product/1)

    variants =
      products
      |> Enum.map(&Map.get(&1, :sync_variants))
      |> Enum.map(&hd/1)
      |> Enum.map(& &1.product.variant_id)
      |> Enum.map(&Printful.Catalog.variant/1)

    products
    |> Enum.zip(variants)
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&apply(Product, :from_printful, &1))
  end

  def get_product(product_id) do
    product = Printful.Store.product(product_id)

    catalog_variant_id = hd(product.sync_variants).product.variant_id
    catalog = Printful.Catalog.variant(catalog_variant_id)

    variants =
      product
      |> Map.get(:sync_variants)
      |> Enum.map(&Map.get(&1, :id))
      |> Enum.map(&get_variant/1)

    product
    |> Product.from_printful(catalog)
    |> Map.put(:variants, variants)
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
