defmodule Elementary.StoreWeb.CartPlug do
  @moduledoc """
  Sets default cart struct in session data if it does not exist already.
  """

  import Plug.Conn

  def init(_), do: nil

  def call(conn, _) do
    conn = maybe_create(conn)
    assign(conn, :cart, get_session(conn, :cart))
  end

  defp maybe_create(conn) do
    if conn |> get_session(:cart) |> is_nil() do
      put_session(conn, :cart, create(conn))
    else
      conn
    end
  end

  defp create(conn) do
    Elementary.Store.Checkout.create_cart(%{
      locale: Elementary.StoreWeb.Gettext.get_language(conn)
    })
  end
end
