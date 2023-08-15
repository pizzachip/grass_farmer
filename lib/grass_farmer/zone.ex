defmodule GrassFarmer.Zone do

  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :sprinkler_zone, :integer
    field :name, :string, default: "edit to name me"
    field :edit, :boolean, default: false
  end

  def changeset(zone, params \\ %{}) do
    zone
    |> cast(params, [:name, :status])
    |> validate_required([:name, :status])
  end
end
