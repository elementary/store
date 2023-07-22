import Config

config :logger, level: :warn

config :store, Elementary.Store.Mailer, adapter: Swoosh.Adapters.Test
