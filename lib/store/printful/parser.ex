defmodule Elementary.Store.Printful.Parser do
  @moduledoc """
  This is responsible for parsing all of the raw API data we get from Printful
  to useful data. This includes adding categories by string matching. Trying
  to parse size and color information for variants. Etc.
  """

  def parse_product(product) do
    %{
      id: product["id"],
      name: product["name"],
      thumbnail: product["thumbnail_url"],
      category: parse_product_category(product)
    }
  end

  def parse_variants(variant) do
    %{
      id: variant["id"],
      name: variant["name"],
      price: variant["price"]
    }
  end

  defp parse_product_category(%{"name" => name}) do
    if String.contains?(name, "Tee") do
      :apparel
    else
      :accessories
    end
  end
end
