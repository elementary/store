defmodule Elementary.Store.Checkout.Cart do
  @moduledoc """
  Holds all information related to a user's checkout process
  """

  alias Elementary.Store.{Checkout, Shipping}

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  embedded_schema do
    field :items, :map, default: []

    field :name, :string
    field :email, :string
    field :locale, :string

    embeds_one :address, Checkout.Address
    embeds_one :shipping_rate, Shipping.ShippingRate

    field :service_id, :map
  end

  def changeset(%__MODULE__{} = cart, attrs \\ %{}) do
    cart
    |> cast(attrs, [:id, :name, :email, :locale])
    |> cast_embed(:address)
    |> cast_embed(:shipping_rate)
  end
end
