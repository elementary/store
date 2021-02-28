defmodule Elementary.StoreWeb.Checkout.CartController do
  use Elementary.StoreWeb, :controller

  alias Elementary.Store.{Catalog, Checkout}

  def create(conn, %{"id" => variant_id, "cart" => %{"quantity" => quantity}}) do
    variant = Catalog.get_variant(variant_id)

    cart =
      conn
      |> get_session(:cart)
      |> Checkout.add_cart_variant(variant, quantity)

    conn
    |> put_session(:cart, cart)
    |> redirect(to: "/checkout")
  end

  def update(conn, %{"id" => variant_id, "cart" => %{"quantity" => quantity}}) do
    variant = Catalog.get_variant(variant_id)

    cart =
      conn
      |> get_session(:cart)
      |> Checkout.set_cart_variant(variant, quantity)

    conn
    |> put_session(:cart, cart)
    |> redirect(to: "/checkout")
  end

  def delete(conn, %{"id" => variant_id}) do
    variant = Catalog.get_variant(variant_id)

    cart =
      conn
      |> get_session(:cart)
      |> Checkout.remove_cart_variant(variant)

    conn
    |> put_session(:cart, cart)
    |> redirect(to: "/checkout")
  end

  def reset(conn, _params) do
    cart =
      conn
      |> get_session(:cart)
      |> Checkout.remove_cart_variants()

    conn
    |> put_session(:cart, cart)
    |> redirect(to: "/")
  end
end
