defmodule Elementary.Store.Printful.Parser do
  @moduledoc """
  This is responsible for parsing all of the raw API data we get from Printful
  to useful data. This includes adding categories by string matching. Trying
  to parse size and color information for variants. Etc.
  """

  @apparel_keywords ~w(Tee Hoodie)

  def parse_product(products) when is_list(products) do
    products
    |> Enum.filter(&(&1["synced"] !== 0))
    |> Enum.map(&parse_product/1)
  end

  def parse_product(product) do
    %{
      id: product["id"],
      name: product["name"],
      thumbnail: product["thumbnail_url"],
      category: parse_product_category(product)
    }
  end

  def parse_product_and_variants(result) do
    %{
      product: parse_product(result["sync_product"]),
      variants: parse_variant(result["sync_variants"])
    }
  end

  def parse_variant(variants) when is_list(variants) do
    variants
    |> Enum.filter(&(&1["synced"] !== 0))
    |> Enum.map(&parse_variant/1)
  end

  def parse_variant(variant) do
    name = clean_variant_name(variant)
    size = parse_variant_size(variant)
    color = parse_variant_color(variant, size)

    %{
      id: variant["id"],
      name: name,
      description: variant["product"]["name"],
      size: size,
      color: color,
      price: Decimal.new(variant["retail_price"]),
      image: parse_variant_image(variant),
      thumbnail: parse_variant_thumbnail(variant),
      sku: variant["sku"]
    }
  end

  defp parse_product_category(%{"name" => name}) do
    if Enum.any?(@apparel_keywords, &(String.contains?(name, &1))) do
      :apparel
    else
      :accessories
    end
  end

  defp clean_variant_name(%{"name" => name}) do
    name
    |> String.trim()
    |> String.replace(~r/^(.*)\s-\s.*$/, "\\g{1}")
  end

  defp parse_variant_options(%{"product" => %{"name" => name}}) do
    name
    |> String.trim()
    |> String.replace(~r/^.*(\(.*\))$/, "\\g{1}")
    |> String.replace(name, "")
    |> String.trim_leading("(")
    |> String.trim_trailing(")")
    |> String.split(" / ")
    |> Enum.reject(&(&1 === ""))
  end

  defp parse_variant_size_text("XS"), do: :extra_small
  defp parse_variant_size_text("S"), do: :small
  defp parse_variant_size_text("M"), do: :medium
  defp parse_variant_size_text("L"), do: :large
  defp parse_variant_size_text("XL"), do: :extra_large
  defp parse_variant_size_text("2XL"), do: :two_extra_large
  defp parse_variant_size_text("3XL"), do: :three_extra_large
  defp parse_variant_size_text("4XL"), do: :four_extra_large
  defp parse_variant_size_text(_), do: nil

  defp parse_variant_size(variant) do
    variant
    |> parse_variant_options()
    |> last("")
    |> parse_variant_size_text()
  end

  defp parse_variant_color_text("Charcoal-Black Triblend"), do: :charcoal
  defp parse_variant_color_text("Aqua Triblend"), do: :aqua
  defp parse_variant_color_text("Oatmeal Triblend"), do: :oatmeal
  defp parse_variant_color_text("White Fleck Triblend"), do: :white
  defp parse_variant_color_text("Purple Triblend"), do: :purple
  defp parse_variant_color_text(_), do: nil

  defp parse_variant_color(variant, size) do
    variant
    |> parse_variant_options()
    |> Enum.reject(&(&1 === size))
    |> first("")
    |> parse_variant_color_text()
  end

  defp variant_preview_file(variant) do
    Enum.find(variant["files"], %{}, &(&1["type"] === "preview"))
  end

  defp parse_variant_image(variant) do
    variant
    |> variant_preview_file
    |> Map.get("preview_url")
  end

  defp parse_variant_thumbnail(variant) do
    variant
    |> variant_preview_file
    |> Map.get("thumbnail_url")
  end

  # These two functions should be in the standard lib as `List.first` and
  # `List.last` in the next version of Elixir
  defp first(list, default \\ nil)
  defp first([], default), do: default
  defp first([head | _], _default), do: head

  defp last(list, default \\ nil)
  defp last([], default), do: default
  defp last([head], _default), do: head
  defp last([_ | tail], default), do: last(tail, default)
end
