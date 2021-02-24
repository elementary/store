defmodule Elementary.Store.Fulfillment.Order do
  @moduledoc """
  The wrapper around everything needed for an order.
  """

  defstruct [
    :id,
    :address,
    :email,
    :items,
    :locale,
    :shipping_rate
  ]

  def create(cart, address, shipping_rate) do
    %__MODULE__{
      address: Map.drop(address, [:email]),
      email: address.email,
      items: cart,
      locale: Gettext.get_locale(),
      shipping_rate: shipping_rate
    }
  end
end
