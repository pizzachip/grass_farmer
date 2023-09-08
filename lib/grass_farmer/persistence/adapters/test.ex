defmodule GrassFarmer.PersistenceAdapter.Test do
  defstruct [:set_name, :configs]
  @moduledoc """
    The prod module uses PropertyTable to persist data to a file on the target.
    The format for data set is a little weird, i.e., they are key value pairs, but,
    submitted as a keyword list of strings.  The key is the name of the data set, and the value
    can be any data type.
    This implies that data should be saved in 'sets' but can be lists, maps, etc.
  """
  alias GrassFarmer.{ Persist, Schedule }
  alias GrassFarmer.Zones.Zone
  alias GrassFarmer.PersistenceAdapter.Test

  def new(adapter) do
    adapter
  end

  defimpl Persist, for: Test do
    def local_write(_adapter) do
      :ok
    end

    def local_read(adapter) do
      case adapter.set_name do
        "zones"     -> [%Zone{id: Ecto.UUID.generate()}]
        "schedules" -> [%Schedule{id: 1, name: "Schedule 1"}, %Schedule{id: 2, name: "Schedule 2"}]
        _           -> []
      end
    end

    # Should not need in Dev
    def save(adapter) do
      adapter.configs
    end

    # Should not need in Dev
    def load(adapter) do
      adapter.configs
    end
  end

end
