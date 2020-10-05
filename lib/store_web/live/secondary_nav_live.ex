defmodule Elementary.StoreWeb.SecondaryNavLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  alias Elementary.StoreWeb.Gettext, as: Gtext

  @impl true
  def mount(_params, session, socket) do
    new_socket =
      socket
      |> assign(:cart_count, cart_count(session["cart_items"]))

    {:ok, new_socket}
  end

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.LayoutView.render("secondary-nav.html", assigns)
  end

  defp cart_count(items) when is_map(items) do
    items
    |> Map.values()
    |> Enum.reduce(0, &(&1 + &2))
  end

  defp cart_count(_), do: 0
end
