defmodule GrassFarmerFirmwareTest do
  use ExUnit.Case
  doctest GrassFarmerFirmware

  test "greets the world" do
    assert GrassFarmerFirmware.hello() == :world
  end
end
