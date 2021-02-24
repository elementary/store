defmodule Elementary.StoreWeb.ParserPlugReader do
  @moduledoc """
  By default, the `Plug.Parser` plug will decode the body, discard the
  raw body, and only store the decoded value. This reader will also
  store the raw body for webhook verification later on. More information
  is available on the `Plug` hexdoc.

  See https://hexdocs.pm/plug/Plug.Parsers.html#module-custom-body-reader
  """

  def read_body(conn, opts) do
    {:ok, body, conn} = Plug.Conn.read_body(conn, opts)
    conn = update_in(conn.assigns[:raw_body], &[body | &1 || []])
    {:ok, body, conn}
  end
end
