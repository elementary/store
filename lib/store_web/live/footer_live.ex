defmodule Elementary.StoreWeb.FooterLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  @impl true
  def mount(_params, %{"locale" => locale}, socket) do
    Gettext.put_locale(Elementary.StoreWeb.Gettext, locale)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.LayoutView.render("footer.html", assigns)
  end
end
