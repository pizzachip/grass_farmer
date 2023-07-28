defmodule GrassFarmer.WaterSchedule do
  defstruct [:id,
    :name,
    start_time: ~T[07:00:00],
    zones: [%{order: 1, zone_id: 1, duration: 10}],
    days: [1,3,5,7],
    status: :active]
end
