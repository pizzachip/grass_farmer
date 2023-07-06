defmodule GrassFarmerWeb.StyleBlocks.Test do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog
  import GrassFarmerWeb.Components.StyleBlocks

  test "month_string takes and integer and returns a 3-char string" do
    assert month_string(1) == "Jan"
    assert month_string(2) == "Feb"
    assert month_string(3) == "Mar"
    assert month_string(4) == "Apr"
    assert month_string(5) == "May"
    assert month_string(6) == "Jun"
    assert month_string(7) == "Jul"
    assert month_string(8) == "Aug"
    assert month_string(9) == "Sep"
    assert month_string(10) == "Oct"
    assert month_string(11) == "Nov"
    assert month_string(12) == "Dec"
  end

  test "time_format takes a naive date time and a format and returns a string" do
    {:ok, date} = NaiveDateTime.new(~D[2023-07-24], ~T[03:09:00])
    assert time_format(date, :just_date) == "Jul 24"
    assert time_format(date, :just_time) == "03:09"
    assert time_format(date, :full) == "Jul 24, 2023 03:09"
  end
end
