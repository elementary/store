defmodule Elementary.StoreWeb.FallbackController do
  use Elementary.StoreWeb, :controller

  def call(conn, {:error, :timeout}) do
    conn
    |> put_status(:unavailable)
    |> put_view(Elementary.StoreWeb.ErrorView)
    |> render(:"503")
  end
end
