defmodule Elementary.Store.Checkout do
  @moduledoc """
  Handles all the information about a user's checkout process
  """

  import Ecto.Changeset

  alias Elementary.Store.Catalog
  alias Elementary.Store.Checkout.Cart
  alias Elementary.Store.PubSub, as: StorePubSub
  alias Phoenix.PubSub

  @doc """
  Creates a cart struct with the given attrs.
  """
  def create_cart(attrs \\ %{}) do
    with {:ok, data} <- %Cart{} |> Cart.changeset(attrs) |> apply_action(:insert) do
      PubSub.broadcast(StorePubSub, data.id, {:cart_update, data})
    end
  end

  @doc """
  Creates a changeset for changing cart data. Used for tracking errors
  and validation.
  """
  def change_cart(cart, attrs \\ %{}) do
    Cart.changeset(cart, attrs)
  end

  @doc """
  Updates cart data.
  """
  def update_cart(cart, attrs \\ %{}) do
    with {:ok, data} <-cart |> Cart.changeset(attrs) |> apply_action(:update) do
      PubSub.broadcast(StorePubSub, data.id, {:cart_update, data})
    end
  end

  @doc """
  Returns the total amount of items in the cart.
  """
  def get_cart_quantity(cart) do
    cart.items
    |> Enum.filter(fn {quantity, _variant_id} -> is_integer(quantity) end)
    |> Enum.map(fn {quantity, _variant_id} -> quantity end)
    |> Enum.reduce(0, fn a, b -> a + b end)
  end

  @doc """
  Returns a list of `Elementary.Store.Catalog.Variant`s and quantities in the cart.
  """
  def get_cart_variants(cart) do
    cart.items
    |> Enum.filter(fn {quantity, _variant_id} -> is_integer(quantity) end)
    |> Enum.filter(fn {quantity, _variant_id} -> quantity > 0 end)
    |> Enum.map(fn {quantity, variant_id} ->
      {quantity, Catalog.get_variant(variant_id)}
    end)
  end

  @doc """
  Returns information about the variant and quantity in a cart.

  ## Examples

      iex> get_cart_variant(%Cart{}, %Variant{})
      {4, %Variant{}}

      iex> get_cart_variant(%Cart{}, %Variant{})
      {0, %Variant{}}

  """
  def get_cart_variant(cart, variant) do
    cart
    |> get_cart_variants()
    |> Enum.find(fn {_quantity, %{id: variant_id}} ->
      variant_id == variant.id
    end)
    |> case do
      {quantity, _variant} -> {quantity, variant}
      _ -> {0, variant}
    end
  end

  @doc """
  Sets the total quantity of a variant in a cart

  ## Examples

      iex> set_cart_variant(%Cart{}, %Variant{}, 4)
      {:ok, cart}

  """
  def set_cart_variant(cart, variant, quantity) do
    items =
      cart.items
      |> Enum.filter(fn {_quantity, variant_id} -> variant_id != variant.id end)
      |> Map.push({quantity, variant.id})
      |> Enum.filter(fn {quantity, _variant_id} -> is_integer(quantity) end)
      |> Enum.filter(fn {quantity, _variant_id} -> quantity > 0 end)

    update_cart(cart, items: items)
  end

  @doc """
  Adds a quantity to the existing quantity in a cart
  """
  def add_cart_variant(cart, variant, quantity) do
    with {0, _variant_id} <- get_cart_variant(cart, variant) do
      set_cart_variant(cart, variant, quantity)
    else
      {existing_quantity, _variant_id} ->
        set_cart_variant(cart, variant, existing_quantity + quantity)
    end
  end

  @doc """
  Resets the cart items to an empty list.
  """
  def remove_cart_variants(cart) do
    update_cart(cart, items: [])
  end

  @doc """
  Removes variant from a cart
  """
  def remove_cart_variant(cart, variant) do
    items =
      cart.items
      |> Enum.filter(fn {_quantity, variant_id} -> variant_id != variant.id end)
      |> Enum.filter(fn {quantity, _variant_id} -> is_integer(quantity) end)
      |> Enum.filter(fn {quantity, _variant_id} -> quantity > 0 end)

    update_cart(cart, items: items)
  end

  @doc """
  Returns the subtotal price of the cart
  """
  def subtotal(cart) do
    cart
    |> get_cart_variants()
    |> Enum.map(fn {quantity, variant} ->
      variant.price * quantity
    end)
    |> Enum.reduce(0, fn a, b -> a + b end)
  end

  @doc """
  Returns the total price of the cart
  """
  def total(cart) do
    if is_nil(cart.shipping_rate) do
      subtotal(cart)
    else
      subtotal(cart) + cart.shipping_rate.price
    end
  end
end
