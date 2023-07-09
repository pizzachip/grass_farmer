defmodule GrassFarmer.WaterSchedule do
  defstruct [:id,
    :name,
    start_time: 0700,
    zones: [1,2,3,4,5,6],
    duration: 12,
    days: [1,3,5,7],
    status: :active]
end
