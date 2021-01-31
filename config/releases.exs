# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended.
import Config

domain =
  System.get_env("DOMAIN") ||
    raise """
    environment variable DOMAIN is missing.
    Please set this to the domain you are hosting the store on
    """

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

printful_api_key =
  System.get_env("PRINTFUL_API_KEY") ||
    raise """
    environment variable PRINTFUL_API_KEY is missing.
    You can find yours in the Printful settings panel
    https://www.printful.com/dashboard/settings
    """

stripe_secret_key =
  System.get_env("STRIPE_SECRET_KEY") ||
    raise """
    environment variable STRIPE_SECRET_KEY is missing.
    You can find yours in the Stripe API page
    https://dashboard.stripe.com/apikeys
    """

stripe_public_key =
  System.get_env("STRIPE_PUBLIC_KEY") ||
    raise """
    environment variable STRIPE_PUBLIC_KEY is missing.
    You can find yours in the Stripe API page
    https://dashboard.stripe.com/apikeys
    """

if String.starts_with?(stripe_public_key, "sk_") do
  raise """
  environment variable STRIPE_PUBLIC_KEY starts with sk_.
  This indicates you accidently put your secret key instead.
  Please double check to ensure you don't leak secret credentials.
  """
end

config :store, Elementary.StoreWeb.Endpoint,
  url: [host: domain],
  secret_key_base: secret_key_base

config :store, Printful.Api, api_key: printful_api_key

config :stripity_stripe,
  api_key: stripe_secret_key,
  public_key: stripe_public_key
