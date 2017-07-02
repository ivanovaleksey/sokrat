defmodule Sokrat.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    plug_opts = [port: Application.get_env(:plug, :port)]
    children = [
      # Starts a worker by calling: Sokrat.Worker.start_link(arg1, arg2, arg3)
      # worker(Sokrat.Worker, [arg1, arg2, arg3]),
      worker(Sokrat.Robot, []),
      worker(Sokrat.Repo, []),
      Plug.Adapters.Cowboy.child_spec(:http, Sokrat.Router, [], plug_opts)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sokrat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
