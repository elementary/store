defmodule Elementary.StoreWeb.CheckoutView do
  use Elementary.StoreWeb, :view

  alias Elementary.Store.Catalog
  alias Elementary.StoreWeb.Checkout

  def fetch_cart_info(cart) do
    cart
    |> Enum.map(fn {v, q} -> {Catalog.get_variant(v), q} end)
    |> Enum.into([])
  end

  def cart_total(cart) do
    cart
    |> Enum.map(fn {variant, quantity} ->
      {value, _} = Float.parse(variant.price)
      value * quantity
    end)
    |> Enum.reduce(0, fn a, b -> a + b end)
  end

  def state_inputs(states) do
    Enum.map(states, &{&1.name, &1.code})
  end

  def country_inputs(countries) do
    Enum.map(countries, &{&1.name, &1.code})
  end

  defdelegate color_text(color), to: Elementary.StoreWeb.ProductView
  defdelegate size_text(size), to: Elementary.StoreWeb.ProductView
end
