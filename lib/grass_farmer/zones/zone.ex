defmodule GrassFarmer.Zones.Zone do
  alias GrassFarmer.Zones.Zone
  alias GrassFarmer.Schedules.Schedule
  alias GrassFarmer.PersistenceAdapter

  
  @type t :: %__MODULE__{
    id: Ecto.UUID.t(),
    name: String.t(),
    sprinkler_zone: integer() 
  }

  defstruct [:id, :sprinkler_zone, :name]

  @spec create_zone([Zone.t()]) :: [Zone.t()]
  def create_zone(zones) do
    next_sprinkler_zone =
      zones
      |> IO.inspect(label: "zones next_sprinkler_zone")
      |> Enum.reduce(0, fn zone, acc -> max(zone.sprinkler_zone, acc) end)
      # |> String.to_integer
      |> Kernel.+(1)

    new_zones = zones ++ 
      [%Zone{id: Ecto.UUID.generate(), sprinkler_zone: next_sprinkler_zone, name: "Please name me"}]

    save(%{set_name: "zones", configs: new_zones})

    new_zones
  end

  @spec delete_zone([Zone.t()], [Schedule.t()], String.t()) :: [Zone]
  def delete_zone(zones, schedules, zone_id) do
    new_zones =
      zones
      |> Enum.filter(fn zone -> zone.id != zone_id end)

    new_schedules = Schedule.update_schedule_zones(schedules, new_zones)

    save(%{set_name: "zones", configs: new_zones})
    save(%{set_name: "schedules", configs: new_schedules})

    {new_zones, new_schedules}
  end

  @spec update_zone([Zone], String.t()) :: [Zone]
  def update_zone(zones, {zone_id, zone_name, sprinkler_zone}) do
    new_zones =
      zones
      |> Enum.map(fn zone -> 
        if zone.id == zone_id, do: %Zone{zone | name: zone_name, sprinkler_zone: sprinkler_zone},  else: zone end)

    save(%{set_name: "zones", configs: new_zones})

    new_zones
  end

  defp save(updates) do
    PersistenceAdapter.new(updates)
    |> PersistenceAdapter.local_write
    |> PersistenceAdapter.save
  end
end
