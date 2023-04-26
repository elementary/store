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
    |> Enum.filter(fn {_a, b} -> elem(b, 0) == :ok end)
    |> Enum.map(fn {a, b} -> {a, elem(b, 1)} end)
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&apply(Product, :from_printful, &1))
  end

  def get_product(product_id) do
    product = Printful.Store.product(product_id)

    catalog_variant_id = hd(product.sync_variants).product.variant_id
    catalog = Printful.Catalog.variant(catalog_variant_id)

    if elem(catalog, 0) != :ok do
      throw(elem(catalog, 1))
    end

    catalog = elem(catalog, 1)

    variants =
      product
      |> Map.get(:sync_variants)
      |> Enum.map(&Map.get(&1, :id))
      |> Enum.map(&get_variant/1)
      |> Enum.filter(fn {a, _b} -> a == :ok end)
      |> Enum.map(fn {_a, b} -> b end)

    product
    |> Product.from_printful(catalog)
    |> Map.put(:variants, variants)
  end

  def get_variants(product_id) do
    Printful.Store.product(product_id)
    |> Map.get(:sync_variants)
    |> Enum.map(&Map.get(&1, :id))
    |> Enum.map(&get_variant/1)
    |> Enum.filter(fn {a, _b} -> a == :ok end)
    |> Enum.map(fn {_a, b} -> b end)
  end

  def get_variant(variant_id) do
    store = Printful.Store.variant(variant_id)

    case Printful.Catalog.variant(store.product.variant_id) do
      {:ok, catalog} -> {:ok, Variant.from_printful(store, catalog)}
      {:error, reason} -> {:error, reason}
    end
  end
end
