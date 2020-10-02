defmodule Elementary.StoreWeb.LayoutView do
  use Elementary.StoreWeb, :view

  def connection(%{socket: socket}), do: socket
  def connection(%{conn: conn}), do: conn

  defp cart_count(conn) do
    0
  end

  def available_languages() do
    Elementary.StoreWeb.Gettext.known_languages()
  end

  def current_language() do
    Gettext.get_locale()
  end

  def language_path(%{request_path: "/"} = conn, code),
    do: Routes.language_path(conn, :set, code)

  def language_path(conn, code),
    do: Routes.language_path(conn, :set, code, path: conn.request_path)

  defp year() do
    Map.get(DateTime.utc_now(), :year)
  end
end
