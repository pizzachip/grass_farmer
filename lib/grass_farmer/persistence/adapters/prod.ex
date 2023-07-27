defmodule GrassFarmer.PersistenceAdapter.Prod do
  defstruct [:set_name, :configs]
  @moduledoc """
    The prod module uses PropertyTable to persist data to a file on the target.
    The format for data set is a little weird, i.e., they are key value pairs, but,
    submitted as a keyword list of strings.  The key is the name of the data set, and the value
    can be any data type.
    This implies that data should be saved in 'sets' but can be lists, maps, etc.
  """
  alias GrassFarmer.Persist
  alias GrassFarmer.PersistenceAdapter.Prod

  def new(adapter) do
    adapter
  end

  defimpl Persist, for: Prod do
    def local_write(adapter) do
      PropertyTable.put(SettingsTable, [adapter.set_name], adapter.configs)
    end

    def local_read(adapter) do
      PropertyTable.get(SettingsTable, [adapter.set_name])
    end

    def save(_adapter) do
      PropertyTable.snapshot(SettingsTable)
    end

    def load(_adapter) do
      snaps = PropertyTable.get_snapshots(SettingsTable)

      case snaps do
        [] -> nil
        _ -> snaps
              |> List.last
              |> Tuple.to_list
              |> List.first
              |> ( fn id -> PropertyTable.restore_snapshot(SettingsTable, id) end ).()

      end
    end
  end

end
