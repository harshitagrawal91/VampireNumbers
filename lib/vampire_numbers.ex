defmodule VampireNumbers do
    def find_pairs(number) do
      num_length = find_num_length(number)
      half_num_length = div(num_length, 2)
      one_half = trunc(number/ :math.pow(10, half_num_length))
      last  =  round(:math.sqrt(number))
      find_pairs = fn i ->
          if(rem(number, i) == 0) do
            {i, div(number, i)}
          else
            false
          end
      end
      list_all_pairs = Enum.map(one_half..last, find_pairs)
                      |>Enum.reject(fn x -> x == false end)
      list_all_pairs
    end

    def get_factors(n) do
      if rem(find_num_length(n), 2) == 1 do
        false
      else
        half = div(length(to_charlist(n)), 2)
        sorted = Enum.sort(String.codepoints("#{n}"))

        list_all_pairs = find_pairs(n)
        check_two_parts_are_equal =
          fn {a, b} -> find_num_length(a) == half && find_num_length(b) == half end
        check_one_of_them_trailing_zero =
          fn {a, b} -> Enum.count([a, b], fn x -> rem(x, 10) == 0 end) != 2 end
        check_current_pair_equals_original_num =
          fn {a, b} -> Enum.sort(String.codepoints("#{a}#{b}")) == sorted end

        fangs = Enum.filter(list_all_pairs,
          check_two_parts_are_equal)
        |>Enum.filter(check_one_of_them_trailing_zero)
        |>Enum.filter(check_current_pair_equals_original_num)

        lt = [n]
        if(Enum.count(fangs) >=1) do
          output_list  = merge_list(fangs, lt)
          str = ""
          str = String.trim_leading(concat_string(output_list, str))
          str
        else
          false
        end
      end
    end

    defp find_num_length(n), do: length(to_charlist(n))

    defp concat_string([h|t], str) do
      str = str <> " " <> Kernel.inspect(h)
      concat_string(t, str)
    end

    defp concat_string([], str), do: str

    defp merge_list([h|t], lt) do
      {a, b} = h
      lt = lt ++ [a] ++ [b]
      merge_list(t, lt)
    end

    defp merge_list([], lt), do: lt
  end

  defmodule TestVampire  do
    def main(low, high) do
      if(low <= high) do
        low..high |> Task.async_stream(&VampireNumbers.get_factors/1,max_concurrency: 30)
        |>Enum.map(fn({:ok, result}) -> result end)
        |>Enum.reject(fn x -> x == false end)
        |>Enum.each(fn x -> IO.puts(x) end)
      else
        IO.puts("Input Error!! #{low} should be less than equal to #{high}")
      end
    end
  end
