defmodule VoteApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      VoteAppWeb.Telemetry,
      # Start the Ecto repository
      VoteApp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: VoteApp.PubSub},
      # Start Finch
      {Finch, name: VoteApp.Finch},
      # Start the Endpoint (http/https)
      VoteAppWeb.Endpoint
      # Start a worker by calling: VoteApp.Worker.start_link(arg)
      # {VoteApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VoteApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VoteAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
