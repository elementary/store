defmodule Elementary.Store.Session do
  @moduledoc """
  This persistent session data in a user's session cookie.
  """

  import Plug.Conn

  def init(conn) do
    if id(conn) == nil do
      put_session(conn, :session_id, generate_id())
    else
      conn
    end
  end

  def id(conn), do: get_session(conn, :session_id)

  defp generate_id(length \\ 64) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end
end
