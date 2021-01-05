defmodule Elementary.Store.Catalog.Product do
  @moduledoc """
  The basic struct for holding store information
  """

  alias Elementary.Store.Catalog.Category

  @enforce_keys [:id]

  defstruct [:id, :name, :description, :category, :thumbnail_url, :variants]

  @doc """
  Converts some Printful API data to an `Elementary.Store.Catalog.Product`
  struct. This includes consolidating some resources, and renaming some fields.
  """
  def from_printful(product, catalog) do
    struct(__MODULE__,
      id: product.sync_product.id,
      name: product.sync_product.name,
      description: catalog.product.description,
      category: Category.from_printful(catalog),
      thumbnail_url: product.sync_product.thumbnail_url
    )
  end

  @doc """
  Compares two product structs based on the category and name.

  ## Example

    iex> Enum.sort(products, Product)
    [%Product{}, %Product{}]

  """
  def compare(product_one, product_two) do
    cond do
      Category.compare(product_one.category, product_two.category) != :eq ->
        Category.compare(product_one.category, product_two.category)

      product_one.name > product_two.name ->
        :gt

      product_one.name < product_two.name ->
        :lt

      true ->
        :eq
    end
  end
end
