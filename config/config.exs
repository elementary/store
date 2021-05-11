# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :store, namespace: Elementary.Store

# Configures the endpoint
config :store, Elementary.StoreWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3o5PN2VqgVx4MSwejKZsCgvm8J+317FaRDejFSeqUWy+BHVT2aPClx4twNZD9IC2",
  render_errors: [
    accepts: ~w(html json),
    layout: {Elementary.StoreWeb.LayoutView, "error.html"},
    view: Elementary.StoreWeb.ErrorView
  ],
  pubsub_server: Elementary.Store.PubSub,
  server: true,
  gzip: false,
  live_view: [signing_salt: "FhR1Qu+m"]

config :store, Elementary.StoreWeb.Gettext,
  default_locale: "en",
  locales: %{
    "en" => "English",
    "af" => "Afrikaans",
    "ar" => "العَرَبِيَّة",
    "ca" => "català",
    "cs-CZ" => "čeština",
    "de" => "Deutsch",
    "es" => "Español",
    "fi" => "Finnish",
    "fr" => "Français",
    "it" => "Italiano",
    "ja" => "日本語",
    "ko" => "한국어",
    "lt" => "Lietuvių kalba",
    "ms" => "bahasa Melayu",
    "mr" => "मराठी",
    "nb" => "Bokmål",
    "nl" => "Nederlands",
    "pl" => "Polski",
    "pt-BR" => "Português (Brasil)",
    "pt" => "Português (Portugal)",
    "ru" => "Русский",
    "th" => "Thai",
    "sk" => "Slovak",
    "sv" => "Swedish",
    "tr-TR" => "Türkçe",
    "zh-CN" => "简体中文",
    "zh-TW" => "繁體中文"
  }

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tesla, adapter: Tesla.Adapter.Hackney

config :libcluster, topologies: []

config :store, Printful.Api,
  baseUrl: "https://api.printful.com/",
  api_key: "",
  webhook_secret: "",
  enable_purchasing: false

config :store, Printful.Cache,
  primary: [
    gc_interval: 3_600_000,
    backend: :shards
  ]

config :store, Elementary.Store.Mailer, adapter: Bamboo.LocalAdapter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Finally import the secret environment specific config. This can be used if a
# developer has special keys they want to set without worry of being included in
# git.
try do
  import_config "#{Mix.env()}.secret.exs"
rescue
  File.Error -> :no_op
end
