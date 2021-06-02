defmodule Elementary.Store.Catalog.Product do
  @moduledoc """
  The basic struct for holding store information
  """

  alias Elementary.Store.Catalog.Category

  @enforce_keys [:id]

  defstruct [:id, :name, :description, :category, :price_range, :thumbnail_url, :variants]

  @doc """
  Converts some Printful API data to an `Elementary.Store.Catalog.Product`
  struct. This includes consolidating some resources, and renaming some fields.
  """
  def from_printful(product, catalog) do
    price_range =
      product
      |> Map.get(:sync_variants, [])
      |> Enum.map(&Map.get(&1, :retail_price, "0"))
      |> Enum.map(&String.to_float/1)
      |> Enum.sort()

    struct(__MODULE__,
      id: product.sync_product.id,
      name: product.sync_product.name,
      description: catalog.product.description,
      category: Category.from_printful(catalog, product),
      price_range: [hd(price_range), List.last(price_range)],
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
    product_one_name = comparable_string_format(product_one.name)
    product_two_name = comparable_string_format(product_two.name)

    product_one_start_price = Enum.at(product_one.price_range, 0)
    product_two_start_price = Enum.at(product_two.price_range, 0)

    cond do
      Category.compare(product_one.category, product_two.category) != :eq ->
        Category.compare(product_one.category, product_two.category)

      product_one_name > product_two_name ->
        :gt

      product_one_name < product_two_name ->
        :lt

      true ->
        :eq
    end
  end

  defp comparable_string_format(str) do
    ~r/[^\w\s]/u
    |> Regex.replace(str, "", global: false)
    |> String.trim()
  end
end
