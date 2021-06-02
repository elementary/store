defmodule Elementary.Store.Catalog.Category do
  @moduledoc """
  Basic functions for handling categories in Printful.
  """

  @category_order [
    "elementary Developer Weekend",
    "T-Shirts",
    "Outerwear",
    "Mugs",
    "Laptop Sleeves",
    "Posters",
    "Pillows"
  ]

  @doc """
  Converts a printful catalog value to a category. This condenses a lot of ugly
  ones.
  """
  def from_printful(catalog) do
    type = String.downcase(catalog.product.type_name)

    cond do
      String.contains?(type, "t-shirt") -> "T-Shirts"
      String.contains?(type, "jacket") -> "Outerwear"
      String.contains?(type, "sweatshirt") -> "Outerwear"
      String.contains?(type, "hoodie") -> "Outerwear"
      String.contains?(type, "mug") -> "Mugs"
      String.contains?(type, "laptop sleeve") -> "Laptop Sleeves"
      String.contains?(type, "poster") -> "Posters"
      String.contains?(type, "pillow") -> "Pillows"
      String.contains?(type, "edw") -> "elementary Developer Weekend"
      true -> catalog.product.type_name
    end
  end

  @doc """
  Compares two category strings.

  ## Example

    iex> Enum.sort(categories, Category)
    ["T-Shirts", "Outerwear"]

  """
  def compare(category_one, category_two) do
    category_index_one = category_index(category_one)
    category_index_two = category_index(category_two)

    cond do
      category_index_one > category_index_two -> :gt
      category_index_one < category_index_two -> :lt
      true -> :eq
    end
  end

  defp category_index(category) do
    index = Enum.find_index(@category_order, fn c -> c === category end)

    if index == nil do
      99
    else
      index
    end
  end
end
