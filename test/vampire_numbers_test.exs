defmodule VampireNumbersTest do
  use ExUnit.Case
  doctest VampireNumbers

  test "greets the world" do
    assert VampireNumbers.hello() == :world
  end
end
