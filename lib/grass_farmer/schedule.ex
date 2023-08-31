defmodule GrassFarmer.Schedule do
  use Ecto.Schema
  @primary_key {:id, :binary_id, [ autogenerate: false, default: Ecto.UUID.generate ]}
  import Ecto.Changeset

  embedded_schema do
    field :name, :string, default: "name me"
    field :start_time, :time, default: ~T[07:00:00]
    field :days, {:array, :integer}, default: [1,3,5,7]
    field :edit, :boolean, default: false
    field :status, Ecto.Enum, values: [:on, :off], default: :off
    field :zones, {:array, Ecto.UUID}, default: []
  end

  def changeset(schedule, params \\ %{}) do
    schedule
    |> cast(params, [:name, :start_time, :zones, :days, :edit, :status])
    |> validate_required([:name, :start_time, :zones, :days])
  end
end
