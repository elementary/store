import Config

config :logger, level: :warning

config :store, Printful.Api,
  baseUrl: "http://localhost:8081/",
  # OK to enable purchasing here, since we're pointing at the mock API
  enable_purchasing: true

config :store, Elementary.Store.Mailer, adapter: Swoosh.Adapters.Test
