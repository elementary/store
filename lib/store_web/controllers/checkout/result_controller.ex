defmodule Elementary.StoreWeb.Checkout.ResultController do
  use Elementary.StoreWeb, :controller

  alias Elementary.Store.Cart

  def success(conn, _) do
    conn
    |> Cart.clear_items()
    |> render("success.html")
  end
end
