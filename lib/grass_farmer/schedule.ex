defmodule GrassFarmer.Schedule do
  use Ecto.Schema
  @primary_key {:id, :binary_id, [ autogenerate: false, default: Ecto.UUID.generate ]}
  import Ecto.Changeset
  alias GrassFarmer.ScheduleZone

  embedded_schema do
    field :name, :string, default: "name me"
    field :start_time, :time, default: ~T[07:00:00]
    field :days, {:array, :integer}, default: [1,3,5,7]
    field :edit, Ecto.Enum, values: [:false, :edit, :delete], default: false
    field :status, Ecto.Enum, values: [:on, :off], default: :off
    embeds_many :zones, ScheduleZone
  end

  def changeset(schedule, params \\ %{}) do
    schedule
    |> cast(params, [:name, :start_time, :zones, :days, :edit, :status])
    |> validate_required([:name, :start_time, :zones, :days])
  end
end

defmodule GrassFarmer.ScheduleZone do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :zone_id, :binary_id
    field :duration, :integer, default: 10
  end

  def changeset(schedule_zone, params \\ %{}) do
    schedule_zone
    |> cast_embed(:zone, [:zone_id, :duration])
    |> validate_required([:zone_id, :duration])
  end
end
