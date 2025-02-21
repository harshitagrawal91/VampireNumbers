defmodule Vampirenumbers.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Vampirenumbers.Worker.start_link(arg)
      {Task.Supervisor, name: Vampirenumbers.TaskSupervisor, restart: :transient}
      # {Vampirenumbers.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    # opts = [strategy: :one_for_one, name: Vampirenumbers.TaskSupervisor]
    # Supervisor.start_link(children, opts)
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
