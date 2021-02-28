defmodule Elementary.StoreWeb.CheckoutView do
  use Elementary.StoreWeb, :view

  alias Elementary.Store.Catalog
  alias Elementary.StoreWeb.Checkout

  def state_inputs(states) do
    Enum.map(states, &{&1.name, &1.code})
  end

  def country_inputs(countries) do
    Enum.map(countries, &{&1.name, &1.code})
  end
end
