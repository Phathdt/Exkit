defmodule ExkitTest do
  use ExUnit.Case
  doctest Exkit

  test "greets the world" do
    assert Exkit.hello() == :world
  end
end
