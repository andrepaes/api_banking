defmodule ApiBanking.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      ApiBanking.Repo,
      ApiBankingWeb.Endpoint,
      {ConCache,
       [
         name: :guardian_ets,
         ttl_check_interval: :timer.seconds(1),
         global_ttl: :timer.minutes(10),
         touch_on_read: true
       ]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ApiBanking.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ApiBankingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
