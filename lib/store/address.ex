defmodule Elementary.Store.Address do
  @moduledoc """
  Handles persistents of the user's shipping address in the user's session. Also
  broadcasts changes on the PubSub so live view can update without a browser
  reload. This will also do some eventual IP lookup to guess shipping prices in
  the future.
  """

  alias Elementary.Store.PubSub, as: StorePubSub
  alias Elementary.Store.Session
  alias Phoenix.PubSub

  import Plug.Conn

  @session_key :address

  def init(conn) do
    if conn |> get_session(@session_key) |> initialized?() do
      conn
    else
      put_session(conn, @session_key, %{})
    end
  end

  def get_address(conn) do
    get_session(conn, @session_key)
  end

  def set_address(conn, address) do
    PubSub.broadcast(StorePubSub, Session.id(conn), {:address_update, address})
    put_session(conn, @session_key, address)
  end

  defp initialized?(address) when is_map(address), do: true
  defp initialized?(_address), do: false
end
