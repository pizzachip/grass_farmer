defmodule GrassFarmer.Loader do
  alias GrassFarmer.{ PersistenceAdapter, CoreDefaults }

  @spec load() :: :ok
  def load() do
    for set <- set_names() do
      PersistenceAdapter.new(%{set_name: set, configs: nil})
      |> exists_in_mem?
      |> load_from_persistence_if_needed
      |> load_core_defaults_if_needed
    end

    PersistenceAdapter.new(%{set_name: nil, configs: nil})
    |> PersistenceAdapter.save
  end

  @spec translate() :: map()
  def translate() do
    prop_list =
      PropertyTable.get_all(SettingsTable)
      |> IO.inspect(label: "prop_list")

    map_list =
      for {set_name, configs} <- prop_list do
        {List.first(set_name) |> String.to_atom,
         configs}
      end

    map_list |> Enum.into(%{}) |> IO.inspect(label: "map_list")
  end

  defp exists_in_mem?(adapter) do
    data_set =
      PersistenceAdapter.local_read(adapter)
      |> IO.inspect(label: "data_set")

      case data_set do
        nil -> adapter
        _ -> :ok
      end
  end

  defp load_from_persistence_if_needed(adapter) do
    case adapter do
      :ok -> :ok # already loaded - skips to next step
      _ ->
        data_set = PersistenceAdapter.load(adapter)

        case data_set do
          nil -> adapter
          _ -> :ok
        end
    end
  end

  defp load_core_defaults_if_needed(adapter) do
    case adapter do
      :ok -> :ok # already loaded - skips to next step
      _ ->
        PersistenceAdapter.new(
          %{set_name: adapter.set_name,
          configs: CoreDefaults.values()[adapter.set_name]}
        )
        |> PersistenceAdapter.local_write

    end
  end

  def set_names, do: Application.get_env(:grass_farmer, :set_names)
end
