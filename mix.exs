defmodule Elementary.Store.MixProject do
  use Mix.Project

  def project do
    [
      app: :store,
      version: "0.1.0",
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {Elementary.Store.Application, [env: Mix.env()]}
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
      {:swoosh, "~> 1.19"},
      {:multipart, "~> 0.6.0"},
      {:phoenix_swoosh, "~> 1.2"},
      {:castore, "~> 1.0.1"},
      {:credo, "~> 1.7.0", only: :dev, runtime: false},
      {:decimal, "~> 2.0"},
      {:gettext, "~> 1.0.0"},
      {:hackney, "~> 1.14"},
      {:jason, "~> 1.4"},
      {:nebulex, "~> 2.6.1"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:phoenix_live_view, "~> 0.17.5"},
      {:phoenix, "~> 1.6.0"},
      {:plug_cowboy, "~> 2.4"},
      {:shards, "~> 1.0"},
      {:stripity_stripe, "~> 2.10"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:tesla, "~> 1.15.2", override: true}
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
      setup: ["deps.get", "cmd --cd assets npm ci"],
      "assets.deploy": ["cmd --cd assets node build.mjs --deploy", "phx.digest"]
    ]
  end
end
