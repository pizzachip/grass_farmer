defmodule GrassFarmer.Schedule do
  alias GrassFarmer.ScheduleZone

  @type t :: %__MODULE__{
    id: Ecto.UUID.t(),
    name: String.t(),
    start_time: Time.t(),
    days: [integer()],
    zones: [ScheduleZone.t()]
  }

  defstruct [:id, :name, :start_time, :days, :zones]
end

defmodule GrassFarmer.ScheduleZone do

  @type t :: %__MODULE__{
    zone_id: String.t(),
    duration: integer()
  }

  defstruct [:zone_id, :duration]
end
