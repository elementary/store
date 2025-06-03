defmodule Elementary.StoreWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use Elementary.StoreWeb, :controller
      use Elementary.StoreWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: Elementary.StoreWeb
      use Gettext, backend: Elementary.StoreWeb.Gettext

      import Plug.Conn
      import Phoenix.LiveView.Controller

      alias Elementary.StoreWeb.Router.Helpers, as: Routes

      action_fallback Elementary.StoreWeb.FallbackController
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/store_web/templates",
        namespace: Elementary.StoreWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {Elementary.StoreWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def view_helpers do
    quote do
      use Phoenix.HTML
      use Gettext, backend: Elementary.StoreWeb.Gettext

      import Phoenix.LiveView.Helpers
      import Phoenix.View
      import Elementary.StoreWeb.ErrorHelpers
      import Elementary.StoreWeb.ProductHelpers

      alias Elementary.StoreWeb.Endpoint
      alias Elementary.StoreWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
