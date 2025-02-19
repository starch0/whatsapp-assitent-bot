defmodule Zapbot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ZapbotWeb.Telemetry,
      Zapbot.Repo,
      {DNSCluster, query: Application.get_env(:zapbot, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Zapbot.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Zapbot.Finch},
      # Start a worker by calling: Zapbot.Worker.start_link(arg)
      # {Zapbot.Worker, arg},
      # Start to serve requests, typically the last entry
      ZapbotWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Zapbot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ZapbotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
