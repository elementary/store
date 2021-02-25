defmodule Elementary.StoreWeb.Webhook.PrintfulController do
  use Elementary.StoreWeb, :controller

  alias Elementary.Store.{Email, Mailer}

  def index(conn, %{"type" => "product_updated"}) do
    Printful.Cache.flush()
    Task.async(&Elementary.Store.Catalog.get_products/0)

    conn
    |> put_status(:ok)
    |> json(%{"status" => "ok"})
  end

  def index(conn, %{"type" => "package_shipped", "data" => data}) do
    data = Jason.decode(data, keys: :atoms)

    data.order
    |> Email.package_shipped(data.shipment)
    |> Mailer.deliver_later()

    conn
    |> put_status(:ok)
    |> json(%{"status" => "ok"})
  end
end
