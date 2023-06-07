defmodule Dian.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      DianWeb.Telemetry,
      # Start the Ecto repository
      Dian.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Dian.PubSub},
      # Start the Endpoint (http/https)
      DianWeb.Endpoint,
      # Start the Finch HTTP client for Tesla
      {Finch, name: FinchClient}
      # Start a worker by calling: Dian.Worker.start_link(arg)
      # {Dian.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dian.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DianWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
