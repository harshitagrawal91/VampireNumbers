defmodule TestVampire do
  def main(low, high) do
    if(low <= high) do
      {:ok, super_pid} = Vampire_supervisor.invoke_supervisor()
      Vampire_supervisor.
        find_vampire_number_by_gen_server_spawn({low, high, super_pid})
    else
      IO.puts("Input Error!! #{low} should be less than equal to #{high}")
    end
  end
end
