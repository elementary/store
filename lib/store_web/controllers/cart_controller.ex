defmodule Elementary.StoreWeb.CartController do
  use Elementary.StoreWeb, :controller

  alias Elementary.Store.Printful
  alias Elementary.StoreWeb.Gettext, as: Gtext

  def update(conn, %{"cart" => %{"operation" => "add", "variant_id" => variant_id} = params}) do
    {quantity, _} = params |> Map.get("quantity", "1") |> Integer.parse()

    case Printful.variant(variant_id) do
      {:ok, variant} ->
        conn
        |> update_items(:add, variant_id, quantity)
        |> put_flash(
          :info,
          dgettext("product", "Added %{product} to cart", product: variant.name)
        )
        |> redirect(to: Routes.index_path(conn, :index))

      res ->
        res
    end
  end

  defp update_items(conn, :add, id, quantity \\ 1) do
    current = current_cart_items(conn)
    current_quantity = Map.get(current, id, 0)
    new_quantity = current_quantity + quantity

    put_session(conn, :cart_items, Map.put(current, id, new_quantity))
  end

  defp current_cart_items(conn) do
    if get_session(conn, :cart_items) == nil do
      []
    else
      get_session(conn, :cart_items)
    end
  end
end
