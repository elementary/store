defmodule Elementary.Store.Shipping do
  @moduledoc """
  Entry point for handling all shipping data
  """

  alias Elementary.Store.{Catalog, Shipping}

  def get_countries() do
    Printful.Shipping.countries()
  end

  def get_states(country_code) do
    Printful.Shipping.countries()
    |> Enum.find(%{}, &(&1.code === country_code))
    |> Map.get(:states, [])
  end

  def get_rates(address, cart) do
    items =
      cart
      |> Enum.map(fn {v, q} -> {Catalog.get_variant(v), q} end)
      |> Enum.map(fn {v, q} -> %{variant_id: v.catalog_variant_id, quantity: q} end)

    %{
      recipient: %{
        address1: address.line1,
        city: address.city,
        country_code: address.country,
        state_code: address.state,
        zip: address.postal
      },
      items: items
    }
    |> Printful.Shipping.rates()
    |> Enum.map(&Shipping.Rate.from_printful/1)
  end
end
