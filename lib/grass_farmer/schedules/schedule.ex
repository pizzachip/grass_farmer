defmodule GrassFarmer.Schedules.Schedule do
  alias GrassFarmer.Schedules.ScheduleZone
  alias GrassFarmer.PersistenceAdapter

  @type t :: %__MODULE__{
    id: Ecto.UUID.t(),
    name: String.t(),
    start_time: Time.t(),
    days: [integer()],
    zones: [ScheduleZone.t()]
  }

  defstruct [:id, :name, :start_time, :days, :zones]

  @spec create_schedule([__MODULE__.t()]) :: [__MODULE__.t()]
  def create_schedule(schedules) do
    schedule = %__MODULE__{id: Ecto.UUID.generate(), name: "New Schedule", zones: [], start_time: ~T[00:07:00]}
    schedules = schedules ++ [schedule]
    write_schedules(schedules)

    { schedules, schedule.id }
  end

  @spec delete([__MODULE__.t()], Ecto.UUID.t()) :: [__MODULE__.t()]
  def delete(schedules, id) do
    new_schedules =
      schedules
      |> Enum.filter(fn schedule -> schedule.id != id end)

    write_schedules(new_schedules)

    new_schedules
  end

  def write_schedules(schedules) do
    PersistenceAdapter.new(%{set_name: "schedules", configs: schedules})
    |> PersistenceAdapter.local_write
    |> PersistenceAdapter.save
  end

  @spec convert_params(%__MODULE__{}, map()) :: %__MODULE__{}
  def convert_params(schedule, params) do
    hours =
      case {params["start_hour"] |> String.to_integer , params["start_am_pm"]} do
       {12, "AM"} -> 0 
       {12, "PM"} -> 12 
       {hour, "AM"} -> hour 
       {hour, "PM"} -> hour + 12
      end

    time = Time.new!(hours, String.to_integer(params["start_minute"]), 0)

    schedule
    |> Map.put(:name, params["name"])
    |> Map.put(:start_time, time)
  end

  @spec temp_update([%__MODULE__{}], map()) :: %__MODULE__{}
  def temp_update(schedules, params) do
    schedules
      |> Enum.map(fn schedule ->
        if schedule.id == params["id"] do
          schedule
          |> __MODULE__.convert_params(params)
        else
          schedule
        end
      end)
  end

end

defmodule GrassFarmer.Schedules.ScheduleZone do

  @type t :: %__MODULE__{
    zone_id: Ecto.UUID.t(),
    duration: integer()
  }

  defstruct [:zone_id, :duration]
end
