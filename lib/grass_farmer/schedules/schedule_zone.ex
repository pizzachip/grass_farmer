defmodule GrassFarmer.Schedules.ScheduleZone do

  @type t :: %__MODULE__{
    zone_id: Ecto.UUID.t(),
    duration: integer()
  }

  defstruct [:zone_id, :duration]
end
