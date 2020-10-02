defmodule Elementary.StoreWeb.IndexView do
  use Elementary.StoreWeb, :view

  def products_in_category(products, category) do
    Enum.filter(products, &(&1.category == category))
  end
end
