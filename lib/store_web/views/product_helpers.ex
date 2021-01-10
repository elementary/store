defmodule Elementary.StoreWeb.ProductHelpers do
  @moduledoc """
  Conveniences for product views. Used in multiple locations.
  """

  use Phoenix.HTML

  def category_slug(category) do
    category
    |> String.replace(~r/[^a-z\s]/i, "")
    |> String.replace(~r/\s/, "-")
    |> String.downcase()
  end

  def format_price(price) when is_binary(price) do
    price |> String.replace(".00", "") |> String.replace(".0", "")
  end

  def format_price(price) when is_float(price) do
    price |> to_string() |> format_price()
  end

  def total_price(price, quantity) do
    {value, _} = Float.parse(price)
    Float.round(value * quantity, 2)
  end
end
