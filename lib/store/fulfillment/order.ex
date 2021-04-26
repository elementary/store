defmodule Elementary.Store.Fulfillment.Order do
  @moduledoc """
  The wrapper around everything needed for an order.
  """

  defstruct [
    :id,
    :address,
    :email,
    :phone_number,
    :items,
    :locale,
    :shipping_rate
  ]

  def create(cart, address, shipping_rate) do
    %__MODULE__{
      address: Map.drop(address, [:email, :phone_number]),
      email: address.email,
      phone_number: address.phone_number,
      items: cart,
      locale: Gettext.get_locale(),
      shipping_rate: shipping_rate
    }
  end
end
