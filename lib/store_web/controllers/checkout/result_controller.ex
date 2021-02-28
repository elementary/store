defmodule Elementary.StoreWeb.Checkout.ResultController do
  use Elementary.StoreWeb, :controller

  alias Elementary.Store.Checkout

  def success(conn, _) do
    cart =
      conn
      |> get_session(:cart)
      |> Checkout.remove_cart_variants()

    conn
    |> put_session(:cart, cart)
    |> render("success.html")
  end
end
