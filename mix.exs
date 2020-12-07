defmodule Elementary.Store.MixProject do
  use Mix.Project

  def project do
    [
      app: :store,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      preferred_cli_env: preferred_cli_env(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      extra_applications: [:cachex, :logger, :runtime_tools],
      mod: {Elementary.Store.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:cachex, "~> 3.3"},
      {:castore, "~> 0.1.0"},
      {:decimal, "~> 2.0"},
      {:gettext, "~> 0.11"},
      {:hackney, "~> 1.13"},
      {:jason, "~> 1.0"},
      {:libcluster, "~> 3.2.1"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_view, "~> 0.15"},
      {:phoenix, "~> 1.5.7"},
      {:plug_cowboy, "~> 2.4"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 0.4"},
      {:tesla, "~> 1.4.0", override: true},
      {:credo, "~> 1.5", only: :dev, runtime: false},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:floki, ">= 0.27.0", only: :test},
      {:wallaby, "~> 0.27.0", runtime: false, only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "cmd npm ci --prefix assets"],
      "test.unit": ["test test/store test/store_web"],
      "test.browser": ["test test/store_client"]
    ]
  end

  defp preferred_cli_env do
    [
      "test.unit": :test,
      "test.browser": :test
    ]
  end
end
