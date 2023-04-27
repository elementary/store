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
      # Get the first variant from the product to populate details with
      |> Enum.map(&hd/1)
      |> Enum.map(& &1.product.variant_id)
      |> Enum.map(&Printful.Catalog.variant/1)

    products
    |> Enum.zip(variants)
    # Filter out any products with variant tuples in error state
    |> Enum.filter(fn {_a, b} -> elem(b, 0) == :ok end)
    # Pull the result out of the ok/variant tuple
    |> Enum.map(fn {a, b} -> {a, elem(b, 1)} end)
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&apply(Product, :from_printful, &1))
  end

  def get_product(product_id) do
    product = Printful.Store.product(product_id)

    catalog_variant_id = hd(product.sync_variants).product.variant_id
    catalog = Printful.Catalog.variant(catalog_variant_id)

    # Failed to get the first variant for a product, this is probably an actual
    # error as we already filtered out products that don't have a first variant,
    # so we throw here
    if elem(catalog, 0) != :ok do
      throw(elem(catalog, 1))
    end

    # Pull the result out of the ok/variant tuple
    catalog = elem(catalog, 1)

    variants =
      product
      |> Map.get(:sync_variants)
      |> Enum.map(&Map.get(&1, :id))
      |> Enum.map(&get_variant/1)
      # Filter out error/variant tuples
      |> Enum.filter(fn {a, _b} -> a == :ok end)
      # Pull the result out of the resulting ok/variant tuples
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
    # Filter out variants that returned errors in the api
    |> Enum.filter(fn {a, _b} -> a == :ok end)
    # Pull the result out of the resulting ok/variant tuples
    |> Enum.map(fn {_a, b} -> b end)
  end

  def get_variant(variant_id) do
    store = Printful.Store.variant(variant_id)

    case Printful.Catalog.variant(store.product.variant_id) do
      {:ok, catalog} -> {:ok, Variant.from_printful(store, catalog)}
      {:error, reason} -> {:error, reason}
    end
  end

  def get_variant!(variant_id) do
    store = Printful.Store.variant(variant_id)
    case Printful.Catalog.variant(store.product.variant_id) do
      {:ok, catalog} -> Variant.from_printful(store, catalog)
      {:error, reason} -> throw(reason)
    end
  end
end
