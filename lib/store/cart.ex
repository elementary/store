defmodule Elementary.Store.Cart do
  @moduledoc """
  Handles persistents of cart data in the user's session. Also broadcasts
  changes on the PubSub so live view can update without a browser reload.
  """

  alias Elementary.Store.PubSub, as: StorePubSub
  alias Elementary.Store.Session
  alias Phoenix.PubSub

  import Plug.Conn

  @session_key :cart

  def init(conn) do
    if conn |> get_session(@session_key) |> initialized?() do
      conn
    else
      put_session(conn, @session_key, %{})
    end
  end

  def get_items(conn) do
    get_session(conn, @session_key)
  end

  def get_item(conn, id) do
    conn
    |> get_session(@session_key)
    |> Map.get(to_string(id), 0)
  end

  def set_items(conn, items) do
    updated_cart =
      items
      |> cast()
      |> Enum.filter(fn {_k, v} -> v > 0 end)
      |> Enum.into(%{})

    PubSub.broadcast(StorePubSub, Session.id(conn), {:cart_update, updated_cart})
    put_session(conn, @session_key, updated_cart)
  end

  def set_item(conn, item, quantity) do
    updated_cart =
      conn
      |> get_items()
      |> Map.put(cast(item), quantity)
      |> Enum.filter(fn {_k, v} -> v > 0 end)
      |> Enum.into(%{})

    PubSub.broadcast(StorePubSub, Session.id(conn), {:cart_update, updated_cart})
    put_session(conn, @session_key, updated_cart)
  end

  def clear_items(conn) do
    set_items(conn, %{})
  end

  def clear_item(conn, item) do
    set_item(conn, item, 0)
  end

  defp cast(values) when is_map(values) do
    values
    |> Enum.map(&cast/1)
    |> Enum.into(%{})
  end

  defp cast({k, v}), do: {to_string(k), String.to_integer(v)}
  defp cast(id), do: to_string(id)

  defp initialized?(cart) when is_map(cart), do: true
  defp initialized?(_cart), do: false
end
