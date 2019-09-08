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
        range_of_threads = 1..20
        range = div((high - low + 1), 20)
        {range_of_threads, range}
      else
        if range_of_vampire_nums <= 10000000 do
          range_of_threads = 1..25
          range = div((high - low + 1), 25)
          {range_of_threads, range}
        else
          range_of_threads = 1..50
          range = div((high - low + 1), 50)
          {range_of_threads, range}
        end
      end
    end
  end
end
