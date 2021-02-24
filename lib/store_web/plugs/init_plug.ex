defmodule Elementary.StoreWeb.InitPlug do
  @moduledoc """
  Sets default values for the cart session data.
  """

  def init(_), do: nil

  def call(conn, _) do
    conn
    |> Elementary.Store.Session.init()
    |> Elementary.Store.Address.init()
    |> Elementary.Store.Cart.init()
  end
end
