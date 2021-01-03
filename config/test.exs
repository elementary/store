import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :store, Elementary.StoreWeb.Endpoint, http: [port: 4002]

config :wallaby,
  base_url: "http://localhost:4002",
  driver: Wallaby.Selenium,
  selenium: [
    capabilities: %{
      browserName: "chrome"
    }
  ],
  opt_app: :store,
  screenshot_dir: Path.expand("#{__DIR__}/../test/store_client_errors"),
  screenshot_on_failure: true,
  sql_sandbox: true

# Print only warnings and errors during test
config :logger, level: :warn

config :store, Printful.Api, api_key: System.get_env("PRINTFUL_API_KEY")
