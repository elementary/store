defmodule Elementary.Store.Catalog.Product do
  @moduledoc """
  The basic struct for holding store information
  """

  @enforce_keys [:id]

  defstruct [:id, :name, :description, :category, :thumbnail_url, :variants]

  def from_printful(product, catalog) do
    struct(__MODULE__,
      id: product.sync_product.id,
      name: product.sync_product.name,
      description: catalog.product.description,
      category: catalog.product.type_name,
      thumbnail_url: product.sync_product.thumbnail_url
    )
  end
end
