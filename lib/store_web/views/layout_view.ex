defmodule Elementary.StoreWeb.LayoutView do
  use Elementary.StoreWeb, :view

  alias Elementary.Store.{Catalog, Cart}

  def connection(%{conn: conn}), do: conn
  def connection(%{socket: socket}), do: socket

  def stripe_key() do
    Application.get_env(:stripity_stripe, :public_key)
  end

  def categories() do
    Catalog.get_products()
    |> Enum.map(& &1.category)
    |> Enum.uniq()
    |> Enum.sort(Catalog.Category)
  end

  def count(%{cart: cart}), do: count(cart)

  def count(%{conn: conn}) do
    conn
    |> Cart.get_items()
    |> count()
  end

  def count(items) when is_map(items) do
    items
    |> Map.values()
    |> Enum.reduce(0, &(&1 + &2))
  end

  def available_languages() do
    Elementary.StoreWeb.Gettext.known_languages()
  end

  def current_language() do
    Gettext.get_locale()
  end

  def language_path(%{request_path: "/"} = conn, code),
    do: Routes.language_url(conn, :set, code)

  def language_path(conn, code) do
    absolute_path =
      conn.request_path
      |> URI.parse()
      |> Map.put(:query, URI.encode_query(locale: code))
      |> URI.to_string()

    Routes.static_url(Endpoint, absolute_path)
  end

  def meta_image(%{assigns: %{page_image: page_image}}), do: page_image
  def meta_image(%{page_image: page_image}), do: page_image
  def meta_image(_conn), do: Routes.static_url(Endpoint, "/images/card.png")

  defp year() do
    Map.get(DateTime.utc_now(), :year)
  end
end
