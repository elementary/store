defmodule Elementary.StoreWeb.EmailView do
  use Elementary.StoreWeb, :view

  def product_preview(item) do
    Enum.find(item.files, &(&1.type === "preview")).thumbnail_url
  end
end
