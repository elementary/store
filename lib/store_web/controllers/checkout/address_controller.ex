defmodule Elementary.StoreWeb.Checkout.AddressController do
  use Elementary.StoreWeb, :controller

  alias Elementary.Store.Address

  def update(conn, %{"address" => address}) do
    conn
    |> Address.set_address(address)
    |> redirect(to: "/checkout")
  end
end
