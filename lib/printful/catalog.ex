defmodule Elementary.Printful.Catalog do
  @moduledoc """
  Handles everything catalog related for Printful.
  """

  alias Elementary.Printful.{Api, Cache, Parser}

  def products() do
    "/store/products"
    |> Api.get(status: "synced", limit: 100)
    |> Enum.filter(&(&1.synced > 0))
    |> Enum.map(&Parser.parse_product/1)
  end

  def product(id) do
    ("/store/products/" <> to_string(id))
    |> Api.get()
    |> Map.get(:sync_product)
    |> Parser.parse_product()
  end

  def variants(id) do
    ("/store/products/" <> to_string(id))
    |> Api.get()
    |> Map.get(:sync_variants)
    |> Enum.map(&Parser.parse_variant/1)
  end

  def variant(id) do
    ("/store/variants/" <> to_string(id))
    |> Api.get()
    |> Parser.parse_variant()
  end
end
