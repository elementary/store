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
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      extra_applications: [:logger, :runtime_tools],
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
      {:bamboo, "~> 2.2.0"},
      {:bamboo_phoenix, "~> 1.0.0"},
      {:castore, "~> 0.1.13"},
      {:credo, "~> 1.6.0", only: :dev, runtime: false},
      {:decimal, "~> 2.0"},
      {:gettext, "~> 0.11"},
      {:hackney, "~> 1.18"},
      {:jason, "~> 1.0"},
      {:libcluster, "~> 3.3.0"},
      {:nebulex, "~> 2.3.0"},
      {:phoenix_html, "~> 3.1.0"},
      {:phoenix_live_reload, "~> 1.3.3", only: :dev},
      {:phoenix_live_view, "~> 0.17.5"},
      {:phoenix, "~> 1.6.2"},
      {:plug_cowboy, "~> 2.5.2"},
      {:shards, "~> 1.0"},
      {:stripity_stripe, "~> 2.12.1"},
      {:telemetry_metrics, "~> 0.6.1"},
      {:telemetry_poller, "~> 1.0.0"},
      {:tesla, "~> 1.4.3", override: true}
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
      setup: ["deps.get", "cmd npm ci --prefix assets"]
    ]
  end
end
