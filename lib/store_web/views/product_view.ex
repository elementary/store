defmodule Elementary.StoreWeb.ProductView do
  use Elementary.StoreWeb, :view

  @variant_keys ~w(color size)a

  def variants(variants, key) do
    variants
    |> Enum.map(&Map.get(&1, key))
    |> Enum.uniq()
  end

  def variant_for(variants, variant, changes \\ []) do
    change_keys = Keyword.keys(changes)
    same_keys = Enum.reject(@variant_keys, &Enum.member?(change_keys, &1))

    variants
    |> Enum.filter(fn v ->
      Enum.all?(same_keys, &(Map.get(variant, &1) === Map.get(v, &1))) and
      Enum.all?(changes, fn {ck, cv} -> Map.get(v, ck) === cv end)
    end)
    |> List.first()
  end

  def color_code_for(variants, color) do
    variants
    |> Enum.find(fn v -> v.color == color end)
    |> Map.get(:color_code)
  end
end
