import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/phoenix_1_6_new start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if System.get_env("PHX_SERVER") do
  config :store, Elementary.StoreWeb.Endpoint, server: true
end

if config_env() == :prod do
  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :store, Elementary.StoreWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

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
end
