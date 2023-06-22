defmodule Dian.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DianWeb.Telemetry,
      Dian.Repo,
      {Phoenix.PubSub, name: Dian.PubSub},
      DianWeb.Endpoint,
      DianWeb.Presence,
      {Finch, name: FinchClient},
      Dian.HotWords
    ]

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
