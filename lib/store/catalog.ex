defmodule Elementary.Store.Catalog do
  @moduledoc """
  Entry point to handle the catalog stuff
  """

  alias Elementary.Printful.Catalog

  def get_products() do
    Catalog.products()
  end

  def get_product(id) do
    Catalog.product(id)
  end

  def get_variants(product_id) do
    Catalog.variants(product_id)
  end

  def get_variant(id) do
    Catalog.variant(id)
  end
end
