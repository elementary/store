defmodule Elementary.StoreWeb.FooterLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  alias Elementary.StoreWeb.Gettext, as: Gtext

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.LayoutView.render("footer.html", assigns)
  end
end
