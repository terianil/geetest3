defmodule Geetest3Test do
  use ExUnit.Case
  doctest Geetest3

  test "greets the world" do
    assert Geetest3.hello() == :world
  end
end
