defmodule Vampire_finder_server do
  use GenServer

  ## External API
  def start_link([]) do
    GenServer.start(__MODULE__, [])
  end

  def init([]) do
    {:ok, [], 5_000_000}
  end

  def calculate_vampire({pid, low, high}) do
    GenServer.cast(pid, {:set_number, low, high})
  end

  def get_vampire(pid) do
    GenServer.call(pid, :next_number)
  end

  ## GenServer Implementation
  def handle_call(:next_number, _from, all_vampire_nums) do
    {:reply, all_vampire_nums, all_vampire_nums}
  end

  def handle_cast({:set_number, low, high}, _) do
    all_vampire_nums = VampireNumbers.get_vampire_nums(low, high)
    {:noreply, all_vampire_nums}
  end

end