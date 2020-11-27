defmodule Elementary.StoreWeb.CartPlug do
  @moduledoc """
  Sets default values for the cart session data.
  """

  def init(_), do: nil

  def call(conn, _) do
    Elementary.Store.Cart.init(conn)
  end
end
