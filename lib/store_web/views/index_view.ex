defmodule Elementary.StoreWeb.IndexView do
  use Elementary.StoreWeb, :view

  def group_by_category(products) do
    products
    |> Enum.group_by(&Map.get(&1, :category))
    |> Enum.sort_by(&elem(&1, 0), :asc)
  end
end
