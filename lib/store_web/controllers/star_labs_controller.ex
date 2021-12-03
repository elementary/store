defmodule Elementary.StoreWeb.StarLabsController do
  use Elementary.StoreWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
