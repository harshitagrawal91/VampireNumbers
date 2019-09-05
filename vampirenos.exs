defmodule VampireNos do
  arguments = System.argv()
   if String.contains?(hd(arguments),".") do
    IO.puts(hd(arguments))
    # Number.printNumber(hd(list))
   else
     [n,k] = arguments
     Test_v.do_test(String.to_integer(n),String.to_integer(k))
   end
end
