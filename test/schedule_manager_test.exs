defmodule GrassFarmerWeb.Components.ScheduleManager.Test do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog

  alias GrassFarmer.{Zone, Schedule, CoreDefaults}
  alias GrassFarmerWeb.Components.ScheduleManager

  test "schedule_edit_zones/2" do
    assert GrassFarmerWeb.StyleBlocks.schedule_edit_zones(CoreDefaults["schedules"], CoreDefaults["zones"]) == [%Zone{id: 1,
      name: "Edit to name me",
      status: "off"}]
  end

end
