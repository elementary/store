defmodule Elementary.StoreWeb.EmailView do
  use Elementary.StoreWeb, :view

  @address_template [
    [:name],
    [:company],
    [:address1],
    [:address2],
    [:city, :state_name],
    [:country_name],
    [:zip]
  ]

  def product_preview(item) do
    case Enum.find(item.files, &(&1.type === "preview")) do
      nil -> nil
      product -> product.thumbnail_url
    end
  end

  def address_template(recipient) do
    @address_template
    |> Enum.map(&address_line_template(recipient, &1))
    |> Enum.reject(&(&1 == ""))
  end

  def address_line_template(recipient, fields) do
    fields
    |> Enum.map(&Map.get(recipient, &1, ""))
    |> Enum.join(" ")
    |> String.replace(~r/\s+/, " ")
    |> String.trim()
  end
end
