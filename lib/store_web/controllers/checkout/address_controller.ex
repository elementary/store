defmodule Elementary.StoreWeb.Checkout.AddressController do
  use Elementary.StoreWeb, :controller

  alias Elementary.Store.Checkout

  def update(conn, %{"address" => address}) do
    conn
    |> Checkout.set_cart_address(address)
    |> redirect(to: "/checkout")
  end
end
