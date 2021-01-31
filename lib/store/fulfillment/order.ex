defmodule Elementary.Store.Fulfillment.Order do
  @moduledoc """
  The wrapper around everything needed for an order.
  """

  defstruct [
    :id,
    :address,
    :email,
    :phone,
    :items,
    :locale,
    :shipping_rate
  ]

  def create(cart, address, shipping_rate) do
    %__MODULE__{
      address: Map.drop(address, [:email, :phone]),
      email: address.email,
      phone: address.phone,
      items: cart,
      locale: Gettext.get_locale(),
      shipping_rate: shipping_rate
    }
  end
end
