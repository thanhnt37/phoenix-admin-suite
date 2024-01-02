defmodule AdminSuite.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AdminSuiteWeb.Telemetry,
      AdminSuite.Repo,
      {DNSCluster, query: Application.get_env(:admin_suite, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AdminSuite.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AdminSuite.Finch},
      # Start a worker by calling: AdminSuite.Worker.start_link(arg)
      # {AdminSuite.Worker, arg},
      # Start to serve requests, typically the last entry
      AdminSuiteWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AdminSuite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AdminSuiteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
