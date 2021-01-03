defmodule Elementary.Store.Catalog.Product do
  @moduledoc """
  The basic struct for holding store information
  """

  @enforce_keys [:id]

  defstruct [:id, :name, :description, :category, :thumbnail_url, :variants]

  def from_printful(product, variants) do
    first_variant = hd(variants)

    struct(__MODULE__,
      id: product.sync_product.id,
      name: product.sync_product.name,
      description: first_variant.description,
      category: first_variant.category,
      thumbnail_url: product.sync_product.thumbnail_url,
      variants: variants
    )
  end
end
