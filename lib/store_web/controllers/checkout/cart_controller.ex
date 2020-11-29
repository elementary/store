defmodule Elementary.StoreWeb.Checkout.CartController do
  use Elementary.StoreWeb, :controller

  alias Elementary.Store.{Cart, Catalog}

  def create(conn, %{"id" => variant_id, "cart" => %{"quantity" => quantity}}) do
    variant = Catalog.get_variant(variant_id)
    current_quantity = Cart.get_item(conn, variant.id)

    conn
    |> Cart.set_item(variant.id, current_quantity + String.to_integer(quantity))
    |> redirect(to: "/checkout")
  end

  def update(conn, %{"id" => variant_id, "cart" => %{"quantity" => quantity}}) do
    variant = Catalog.get_variant(variant_id)

    conn
    |> Cart.set_item(variant.id, String.to_integer(quantity))
    |> redirect(to: "/checkout")
  end

  def delete(conn, %{"id" => variant_id}) do
    variant = Catalog.get_variant(variant_id)

    conn
    |> Cart.clear_item(variant.id)
    |> redirect(to: "/checkout")
  end

  def reset(conn, _params) do
    conn
    |> Cart.clear_items()
    |> redirect(to: "/")
  end
end
