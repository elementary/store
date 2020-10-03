defmodule Elementary.StoreWeb.ProductView do
  use Elementary.StoreWeb, :view

  @variant_keys [:color, :size]

  def variants(product, key) do
    product.variants
    |> Enum.map(&Map.get(&1, key))
    |> Enum.uniq()
  end

  def variant_for(product, variant, changes \\ []) do
    change_keys = Keyword.keys(changes)
    same_keys = Enum.reject([:color, :size], &Enum.member?(change_keys, &1))

    product.variants
    |> Enum.filter(fn v ->
      Enum.all?(same_keys, &(variant[&1] === v[&1]))
    end)
    |> Enum.filter(fn v ->
      Enum.all?(changes, fn {ck, cv} -> v[ck] === cv end)
    end)
    |> List.first()
  end

  def size_text(:extra_small), do: dgettext("product", "XS")
  def size_text(:small), do: dgettext("product", "S")
  def size_text(:medium), do: dgettext("product", "M")
  def size_text(:large), do: dgettext("product", "L")
  def size_text(:extra_large), do: dgettext("product", "XL")
  def size_text(:two_extra_large), do: dgettext("product", "2XL")
  def size_text(:three_extra_large), do: dgettext("product", "3XL")
  def size_text(:four_extra_large), do: dgettext("product", "4XL")
end
