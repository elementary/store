import Config

config :logger, level: :warn

config :store, Elementary.Store.Mailer, adapter: Bamboo.TestAdapter
