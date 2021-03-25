defmodule Elementary.StoreWeb.Router do
  use Elementary.StoreWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Elementary.StoreWeb.LayoutView, "root.html"}
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Elementary.StoreWeb.GettextPlug
    plug Elementary.StoreWeb.InitPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through :browser

      forward "/emails", Bamboo.SentEmailViewerPlug
    end
  end

  scope "/", Elementary.StoreWeb do
    pipe_through :browser

    get "/_health", HealthController, :index

    live "/", IndexLive, :index

    get "/computers/starlabs", StarLabsController, :index

    live "/products/:product", ProductLive, :index
    live "/products/:product/:variant", ProductLive, :index

    live "/checkout", CheckoutLive, :index

    get "/language", LanguageController, :index
    get "/language/:lang", LanguageController, :set

    get "/checkout/success", Checkout.ResultController, :success

    patch "/checkout/address", Checkout.AddressController, :update

    delete "/checkout/cart", Checkout.CartController, :reset
    post "/checkout/cart/:id", Checkout.CartController, :create
    patch "/checkout/cart/:id", Checkout.CartController, :update
    delete "/checkout/cart/:id", Checkout.CartController, :delete
  end

  scope "/webhook", Elementary.StoreWeb.Webhook do
    pipe_through :api

    post "/printful", PrintfulController, :index
    post "/stripe", StripeController, :index
  end
end
