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
    {float, _} = Float.parse(price)
    format_price(float)
  end

  def format_price(price) when is_integer(price) do
    to_string(price)
  end

  def format_price(price) when is_float(price) do
    whole_rounded = Float.round(price, 0)
    usd_rounded = Float.round(price, 2)

    if whole_rounded == usd_rounded do
      :erlang.float_to_binary(whole_rounded, decimals: 0)
    else
      :erlang.float_to_binary(usd_rounded, decimals: 2)
    end
  end

  def total_price(price, quantity) do
    {value, _} = Float.parse(price)
    Float.round(value * quantity, 2)
  end
end
