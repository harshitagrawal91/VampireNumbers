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

defmodule VampireNumbers do
  def get_vampire_nums(lower_bound, upper_bound) do
    get_factors_vampire = fn item ->
      get_factors(item)
    end
    Enum.map(lower_bound..upper_bound, get_factors_vampire)
    |> Enum.reject(fn x -> x == false end)
  end

  def find_pairs(number) do
    num_length = find_num_length(number)
    half_num_length = div(num_length, 2)
    one_half = trunc(number / :math.pow(10, half_num_length))
    last = round(:math.sqrt(number))

    find_pairs = fn i ->
      if(rem(number, i) == 0) do
        {i, div(number, i)}
      else
        false
      end
    end

    list_all_pairs =
      Enum.map(one_half..last, find_pairs)
      |> Enum.reject(fn x -> x == false end)

    list_all_pairs
  end

  def get_factors(n) do
    if rem(find_num_length(n), 2) == 1 do
      false
    else
      half = div(length(to_charlist(n)), 2)
      sorted = Enum.sort(String.codepoints("#{n}"))

      list_all_pairs = find_pairs(n)

      check_two_parts_are_equal = fn {a, b} ->
        find_num_length(a) == half && find_num_length(b) == half
      end

      check_one_of_them_trailing_zero = fn {a, b} ->
        Enum.count([a, b], fn x -> rem(x, 10) == 0 end) != 2
      end

      check_current_pair_equals_original_num = fn {a, b} ->
        Enum.sort(String.codepoints("#{a}#{b}")) == sorted
      end

      fangs =
        Enum.filter(
          list_all_pairs,
          check_two_parts_are_equal
        )
        |> Enum.filter(check_one_of_them_trailing_zero)
        |> Enum.filter(check_current_pair_equals_original_num)

      lt = [n]

      if(Enum.count(fangs) >= 1) do
        output_list = merge_list(fangs, lt)
        str = ""
        str = String.trim_leading(concat_string(output_list, str))
        str
      else
        false
      end
    end
  end

  defp find_num_length(n), do: length(to_charlist(n))

  defp concat_string([h | t], str) do
    str = str <> " " <> Kernel.inspect(h)
    concat_string(t, str)
  end

  defp concat_string([], str), do: str

  defp merge_list([h | t], lt) do
    {a, b} = h
    lt = lt ++ [a] ++ [b]
    merge_list(t, lt)
  end

  defp merge_list([], lt), do: lt
end


defmodule TestVampire do
  def main(low, high) do
    if(low <= high) do
      {:ok, super_pid} = Vampire_supervisor.start_link()
      {range_of_threads, range} = get_thread_config(low, high)

      all_vampire_nums = Enum.map(
                           range_of_threads,
                           fn (index) ->
                             {Vampire_supervisor.start_worker(super_pid), index}
                           end
                         )
                         |> Enum.map(
                              fn ({{:ok, pid}, i}) ->
                                if(i === 1) do
                                  {pid, low, range, i}
                                else
                                  if(i === 10) do
                                    {pid, range * (i - 1) + 1, high, i}
                                  else
                                    {pid, range * (i - 1) + 1, range * i, i}
                                  end
                                end
                              end
                            )
                         |> Enum.map(
                              fn ({child_pid, low, high, _}) ->
                                {
                                  child_pid,
                                  Vampire_finder_server.calculate_vampire({child_pid, low, high})
                                }
                              end
                            )
                         |> Enum.map(
                              fn ({child_pid, _}) ->
                                {
                                  child_pid,
                                  Vampire_finder_server.get_vampire(child_pid)
                                }
                              end
                            )
                         |> Enum.map(
                              fn ({_, list}) ->
                                list
                              end
                            )
                         |> Enum.reject(fn (list) -> Enum.count(list) == 0 end)

      all_vampire_nums = List.flatten(all_vampire_nums)
                         |> Enum.each(fn x -> IO.puts(x) end)

    else
      IO.puts("Input Error!! #{low} should be less than equal to #{high}")
    end
  end

  defp get_thread_config(low, high) do
    range_of_vampire_nums = high - low + 1

    if range_of_vampire_nums <= 1000000 do
      range_of_threads = 1..10
      range = div((high - low + 1), 10)
      {range_of_threads, range}
    else
      if range_of_vampire_nums <= 5000000 do
        range_of_threads = 1..500
        range = div((high - low + 1), 500)
        {range_of_threads, range}
      else
        if range_of_vampire_nums <= 10000000 do
          range_of_threads = 1..1000
          range = div((high - low + 1), 1000)
          {range_of_threads, range}
        else
          range_of_threads = 1..10000
          range = div((high - low + 1), 10000)
          {range_of_threads, range}
        end
      end
    end
  end
end



