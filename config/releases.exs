# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended.
import Config

domain =
  System.get_env("PUBLIC_PORT") ||
    raise """
    environment variable DOMAIN is missing.
    Please set this to the domain you are hosting the store on
    """

port = String.to_integer(System.get_env("PUBLIC_PORT", "80"))

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :store, Elementary.StoreWeb.Endpoint,
  url: [host: domain, port: port],
  secret_key_base: secret_key_base
