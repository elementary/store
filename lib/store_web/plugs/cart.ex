defmodule Elementary.StoreWeb.CartPlug do
  @moduledoc """
  Sets default values for the cart session data.
  """

  def init(_), do: nil

  def call(conn, _) do
    if Plug.Conn.get_session(conn, :cart_items) == nil do
      Plug.Conn.put_session(conn, :cart_items, %{})
    else
      conn
    end
  end
end
