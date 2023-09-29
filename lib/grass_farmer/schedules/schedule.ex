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
    schedule = %__MODULE__{id: Ecto.UUID.generate(), name: "New Schedule", zones: [], days: 1..7, start_time: ~T[00:07:00]}
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

  @spec toggle_zone(UUID.t(), UUID.t(), [__MODULE__.t()]) :: [__MODULE__.t()]
  def toggle_zone(schedule_id, zone_id, schedules) do
    zones =
      schedules
      |> Enum.filter(fn schedule -> schedule.id == schedule_id end)
      |> List.first
      |> Map.get(:zones)
      |> add_inclusion_flag(zone_id)
      |> remove_if_included(zone_id)
      |> add_if_excluded(zone_id)

    Enum.map(schedules, fn schedule -> 
      if schedule.id == schedule_id do
        Map.merge(schedule, %{zones: zones})
      else
        schedule
      end
    end)
  end

  def add_inclusion_flag(zones, zone_id) do
    included = 
      Enum.filter(zones, fn zone -> zone.zone_id == zone_id end)
      |> length

    { zones, 
      case included do
        0 -> :excluded
        _ -> :included 
      end
    }
  end

  def remove_if_included({zones, inclusion}, zone_id) do
    case inclusion do
      :included ->
        { Enum.filter(zones, fn zone -> zone.zone_id != zone_id end), :included }  
      :excluded -> {zones, :excluded}
    end
  end

  @spec add_if_excluded({[ScheduleZone.t()], atom()}, UUID.t()) :: [Zones.t()]
  def add_if_excluded({zones, inclusion}, zone_id) do
    zone_to_add = %GrassFarmer.Schedules.ScheduleZone{zone_id: zone_id, duration: 10}
    case inclusion do
      :included -> zones
      :excluded -> zones ++ [zone_to_add]
    end
  end

  @spec toggle_day([Schedule.t()], UUID.t(), integer()) :: [Shedule.t()]
  def toggle_day(schedules, schedule_id, day) do
    Enum.map(schedules, fn schedule -> 
      if schedule.id == schedule_id do
        if schedule.days |> Enum.member?(day) do
          Map.merge(schedule, %{days: Enum.filter(schedule.days, fn d -> d != day end)})
        else
          Map.merge(schedule, %{days: schedule.days ++ [day]})
        end
      else
        schedule
      end
    end)
  end

  def write_schedules(schedules) do
    PersistenceAdapter.new(%{set_name: "schedules", configs: schedules})
    |> PersistenceAdapter.local_write
    |> PersistenceAdapter.save
  end

  @spec convert_params(%__MODULE__{}, map()) :: %__MODULE__{}
  def convert_params(schedule, params) do
    IO.inspect(schedule, label: "schedule convert_params")
    IO.inspect(params, label: "params convert_params")
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
    |> IO.inspect(label: "return schedule convert_params")
  end

  @spec temp_update([%__MODULE__{}], map()) :: %__MODULE__{}
  def temp_update(schedules, params) do
    schedules
      |> Enum.map(fn schedule ->
        if schedule.id == params["id"] do
          schedule
          |> __MODULE__.convert_params(params)
          |> IO.inspect(label: "schedule temp_update in workflow")
          |> Map.merge(%{zones: schedule.zones})
        else
          schedule
        end
      end)
  end

  def get_schedules() do
    PersistenceAdapter.new(%{set_name: "schedules", configs: nil})
    |> PersistenceAdapter.local_read
    |> Enum.filter(fn schedule -> schedule.id != nil end)
  end

  @spec update_schedule_zones([Schedule.t()], [Zone.t()]) :: [Schedule.t()]
  def update_schedule_zones(schedules, zones) do
    zone_ids = Enum.map(zones, fn zone -> zone.id end)

    schedules
    |> Enum.map(fn schedule -> #I need to return a schedule with an updated zones list
      Map.put(schedule, :zones,
        schedule.zones
        |> Enum.reduce([], fn zone, acc -> 
           if Enum.member?(zone_ids, zone.zone_id) do
             acc ++ [zone]
           else
            acc
          end
        end)
        )
    end)
  end

end

