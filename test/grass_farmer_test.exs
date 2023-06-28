defmodule GrassFarmerTest do
  use ExUnit.Case
  doctest GrassFarmer

  test "greets the world" do
    assert GrassFarmer.hello() == :world
  end
end
