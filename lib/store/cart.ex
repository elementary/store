defmodule Elementary.Store.Cart do
  @moduledoc """
  This handles most of the catalog stuff for a `Plug.Conn`. It's abstracted to
  this file to avoid all of the messy logic everywhere else.
  """

  alias Elementary.Store.PubSub, as: StorePubSub
  alias Phoenix.PubSub

  import Plug.Conn

  def init(conn) do
    if id(conn) == nil do
      conn
      |> put_session(:cart_id, generate_id())
      |> put_session(:cart, %{})
    else
      conn
    end
  end

  def get_items(conn) do
    get_session(conn, :cart)
  end

  def get_item(conn, id) do
    conn
    |> get_session(:cart)
    |> Map.get(to_string(id), 0)
  end

  def set_items(conn, items) do
    updated_cart =
      items
      |> cast()
      |> Enum.filter(fn {_k, v} -> v > 0 end)
      |> Enum.into(%{})

    PubSub.broadcast(StorePubSub, id(conn), {:cart_update, updated_cart})
    put_session(conn, :cart, updated_cart)
  end

  def set_item(conn, item, quantity) do
    updated_cart =
      conn
      |> get_items()
      |> Map.put(cast(item), quantity)
      |> Enum.filter(fn {_k, v} -> v > 0 end)
      |> Enum.into(%{})

    PubSub.broadcast(StorePubSub, id(conn), {:cart_update, updated_cart})
    put_session(conn, :cart, updated_cart)
  end

  def clear_items(conn) do
    set_items(conn, %{})
  end

  def clear_item(conn, item) do
    set_item(conn, item, 0)
  end

  defp id(conn), do: get_session(conn, :cart_id)

  defp cast(values) when is_map(values) do
    values
    |> Enum.map(&cast/1)
    |> Enum.into(%{})
  end

  defp cast({k, v}), do: {to_string(k), String.to_integer(v)}
  defp cast(id), do: to_string(id)

  defp generate_id(length \\ 64) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end
end
