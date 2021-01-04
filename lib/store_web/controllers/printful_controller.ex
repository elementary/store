defmodule Elementary.StoreWeb.PrintfulController do
  use Elementary.StoreWeb, :controller

  @address_fields ~w(
    name email phone address1 address2 city state_code zip country_code
  )a

  @tracking_fields ~w(
    tracking_number tracking_url carrier service
  )a

  def index(conn, %{"type" => "product_updated"}) do
    Printful.Cache.clear()

    conn
    |> put_status(:ok)
    |> json(%{"status" => "ok"})
  end

  def index(conn, %{"type" => "package_shipped", "data" => data}) do
    address =
      data
      |> Map.get("order", %{})
      |> Map.get("recipient")
      |> parse_map(@address_fields)

    tracking =
      data
      |> Map.get("shipment")
      |> parse_map(@tracking_fields)

    items =
      data
      |> Map.get("order", %{})
      |> Map.get("items", [])

    conn
    |> put_status(:ok)
    |> json(%{"status" => "ok"})
  end

  defp parse_map(map, fields) do
    fields
    |> Enum.map(fn f -> {f, Map.get(map, to_string(f))} end)
    |> Enum.into(%{})
  end
end
