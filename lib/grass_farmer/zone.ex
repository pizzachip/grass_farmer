defmodule GrassFarmer.Zone do
  use Ecto.Schema
  @primary_key {:id, Ecto.UUID, autogenerate: false}
  import Ecto.Changeset

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
end
