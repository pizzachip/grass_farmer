defmodule GrassFarmer.Zones.Zone do
  use Ecto.Schema
  @primary_key {:id, Ecto.UUID, autogenerate: false}
  import Ecto.Changeset
  alias GrassFarmer.Zones.Zone
  alias GrassFarmer.PersistenceAdapter

  embedded_schema do
    field :sprinkler_zone, :integer
    field :name, :string, default: "edit to name me"
    field :edit, :boolean, default: false
  end

  def changeset(zone, params \\ %{}) do
    zone
    |> cast(params, [:name, :sprinkler_zone, :edit])
    |> validate_required([:name, :sprinkler_zone, :edit])
  end

  @spec create_zone([Zone]) :: [Zone]
  def create_zone(zones) do
    next_sprinkler_zone =
      zones
      |> Enum.reduce(0, fn zone, acc -> max(zone.sprinkler_zone, acc) end)

    new_zones = zones ++ [%Zone{id: Ecto.UUID.generate(), sprinkler_zone: next_sprinkler_zone + 1, edit: true}]

    local_write(%{set_name: "zones", configs: new_zones})

    new_zones
  end

  @spec delete_zone([Zone], String.t()) :: [Zone]
  def delete_zone(zones, zone_id) do
    new_zones =
      zones
      |> Enum.filter(fn zone -> zone.id != zone_id end)

    local_write(%{set_name: "zones", configs: new_zones})

    new_zones
  end

  defp local_write(zone_updates) do
    PersistenceAdapter.new(zone_updates)
    |> PersistenceAdapter.local_write
    |> PersistenceAdapter.save
  end

end
