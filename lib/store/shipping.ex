defmodule Elementary.Store.Shipping do
  @moduledoc """
  Entry point for handling all shipping data
  """

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
      Enum.map(cart, fn {variant_id, quantity} ->
        variant = Elementary.Store.Catalog.get_variant(variant_id)

        %{
          variant_id: variant.variant_id,
          quantity: quantity
        }
      end)

    Printful.Shipping.rates(%{
      recipient: %{
        address1: address.line1,
        city: address.city,
        country_code: address.country,
        state_code: address.state,
        zip: address.postal
      },
      items: items
    })
  end
end
