defmodule GrassFarmer.Zones.Zone do
  alias GrassFarmer.Zones.Zone
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
      |> Enum.reduce(0, fn zone, acc -> max(zone.sprinkler_zone, acc) end)
      |> IO.inspect(label: "next zone")

    new_zones = zones ++ 
      [%Zone{id: Ecto.UUID.generate(), sprinkler_zone: (next_sprinkler_zone + 1), name: "Please name me"}]

    save(%{set_name: "zones", configs: new_zones})

    new_zones
  end

  @spec delete_zone([Zone], String.t()) :: [Zone]
  def delete_zone(zones, zone_id) do
    new_zones =
      zones
      |> Enum.filter(fn zone -> zone.id != zone_id end)

    save(%{set_name: "zones", configs: new_zones})

    new_zones
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

  defp save(zone_updates) do
    PersistenceAdapter.new(zone_updates)
    |> PersistenceAdapter.local_write
    |> PersistenceAdapter.save
  end
end
