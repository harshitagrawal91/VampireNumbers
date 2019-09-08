defmodule Vampire_supervisor do
  use DynamicSupervisor

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_worker(super_pid) do
    child_spec = {Vampire_finder_server, []}
    DynamicSupervisor.start_child(super_pid, child_spec)
  end
end