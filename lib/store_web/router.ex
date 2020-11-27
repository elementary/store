defmodule Elementary.StoreWeb.Router do
  use Elementary.StoreWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Elementary.StoreWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Elementary.StoreWeb.GettextPlug
    plug Elementary.StoreWeb.CartPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Elementary.StoreWeb do
    pipe_through :browser

    get "/_health", HealthController, :index

    live "/", IndexLive, :index

    live "/products/:product", ProductLive, :index
    live "/products/:product/:variant", ProductLive, :index

    live "/checkout", CheckoutLive, :index

    get "/language", LanguageController, :index
    get "/language/:lang", LanguageController, :set

    delete "/cart", CartController, :reset
    post "/cart/:id", CartController, :create
    patch "/cart/:id", CartController, :update
    delete "/cart/:id", CartController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Elementary.StoreWeb do
  #   pipe_through :api
  # end
end
