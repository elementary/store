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
end
