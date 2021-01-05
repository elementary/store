defmodule Elementary.Store.Catalog.Variant do
  @moduledoc """
  The basic struct for holding store information
  """

  @enforce_keys [:id]

  defstruct [
    :id,
    :name,
    :description,
    :size,
    :color,
    :color_code,
    :price,
    :thumbnail_url,
    :preview_url
  ]

  @doc """
  Converts some Printful API data to an `Elementary.Store.Catalog.Variant`
  struct. This includes consolidating some resources, and renaming some fields.
  """
  def from_printful(store, catalog) do
    mockup = Enum.find(store.files, &(&1.type === "preview"))

    struct(__MODULE__,
      id: store.id,
      name: store.name,
      description: catalog.product.description,
      size: catalog.variant.size,
      color: catalog.variant.color,
      color_code: catalog.variant.color_code,
      price: store.retail_price,
      thumbnail_url: mockup.thumbnail_url,
      preview_url: mockup.preview_url
    )
  end
end
