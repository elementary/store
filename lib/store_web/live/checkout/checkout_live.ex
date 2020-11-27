defmodule Elementary.StoreWeb.CheckoutLive do
  @moduledoc false

  use Elementary.StoreWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Cart")}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    Elementary.StoreWeb.CheckoutView.render("index.html", assigns)
  end
end
