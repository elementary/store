defmodule Elementary.Store.Catalog.Variant do
  @moduledoc """
  The basic struct for holding store information
  """

  @enforce_keys [:id]

  defstruct [
    :id,
    :product_id,
    :catalog_variant_id,
    :name,
    :description,
    :size,
    :color,
    :color_code,
    :price,
    :available,
    :thumbnail_url,
    :preview_url,
    :printful_files
  ]

  @doc """
  Converts some Printful API data to an `Elementary.Store.Catalog.Variant`
  struct. This includes consolidating some resources, and renaming some fields.
  """
  def from_printful(store, catalog) do
    mockup = Enum.find(store.files, &(&1.type === "preview"))
    {price, _} = Float.parse(store.retail_price)

    files =
      Enum.map(store.files, fn file ->
        Map.take(file, [:id, :preview_url, :thumbnail_url, :type])
      end)

    struct(__MODULE__,
      id: store.id,
      product_id: store.sync_product_id,
      catalog_variant_id: store.variant_id,
      name: store.name,
      description: catalog.product.description,
      size: catalog.variant.size,
      color: catalog.variant.color,
      color_code: catalog.variant.color_code,
      price: price,
      available: not catalog.product.is_discontinued and catalog.variant.in_stock,
      thumbnail_url: mockup.thumbnail_url,
      preview_url: mockup.preview_url,
      printful_files: files
    )
  end
end
