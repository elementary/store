defmodule Elementary.StoreWeb.IndexView do
  use Elementary.StoreWeb, :view

  def group_by_category(products) do
    products
    |> Enum.sort(Elementary.Store.Catalog.Product)
    |> Enum.group_by(&Map.get(&1, :category))
    |> Enum.sort_by(&elem(&1, 0), Elementary.Store.Catalog.Category)
  end
end
