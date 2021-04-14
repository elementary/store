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

printful_webhook_secret =
  System.get_env("PRINTFUL_WEBHOOK_SECRET") ||
    raise """
    environment variable PRINTFUL_WEBHOOK_SECRET is missing.
    You must create one and add it to the webhook path at
    https://www.printful.com/docs/webhooks
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

stripe_webhook_secret =
  System.get_env("STRIPE_WEBHOOK_SECRET") ||
    raise """
    environment variable STRIPE_WEBHOOK_SECRET is missing.
    You can find yours in the Stripe API page
    https://dashboard.stripe.com/webhooks
    """

mailgun_api_key =
  System.get_env("MAILGUN_API_KEY") ||
    raise """
    environment variable MAILGUN_API_KEY is missing.
    You can find yours in the mailgun settings page
    https://app.mailgun.com/app/account/security/api_keys
    """

mailgun_domain =
  System.get_env("MAILGUN_DOMAIN") ||
    raise """
    environment variable MAILGUN_DOMAIN is missing.
    You can find yours in the mailgun settings page
    https://app.mailgun.com/app/sending/domains
    """

config :store, Elementary.StoreWeb.Endpoint,
  url: [host: domain],
  secret_key_base: secret_key_base

config :store, Printful.Api,
  api_key: printful_api_key,
  webhook_secret: printful_webhook_secret

config :stripity_stripe,
  api_key: stripe_secret_key,
  public_key: stripe_public_key,
  webhook_secret: stripe_webhook_secret

config :store, Elementary.Store.Mailer,
  api_key: mailgun_api_key,
  domain: mailgun_domain
