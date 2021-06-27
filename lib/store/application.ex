defmodule Elementary.Store.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies)

    children = [
      # Start the Telemetry supervisor
      Elementary.StoreWeb.Telemetry,
      # Start clustering logic
      {Cluster.Supervisor, [topologies, [name: Elementary.Store.ClusterSupervisor]]},
      # Start the Printful API cache
      Printful.Cache,
      # Start the fulfillment cleaner
      Elementary.Store.Fulfillment.Cleaner,
      # Start the PubSub system
      {Phoenix.PubSub, name: Elementary.Store.PubSub},
      # Start the Endpoint (http/https)
      {Elementary.StoreWeb.Endpoint, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Elementary.Store.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Elementary.StoreWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
