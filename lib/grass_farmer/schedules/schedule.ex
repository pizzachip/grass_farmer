defmodule GrassFarmer.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :start_time, :time, default: ~T[07:00:00]
    field :zones, {:array, :map}, default: []
    field :days, {:array, :integer}, default: [1,3,5,7]
    field :edit, :boolean, default: false
    field :status, Ecto.Enum, values: [:on, :off], default: :off
  end

  def changeset(schedule, params \\ %{}) do
    schedule
    |> cast(params, [:name, :start_time, :zones, :days, :edit, :status])
    |> validate_required([:name, :start_time, :zones, :days])
  end
end
