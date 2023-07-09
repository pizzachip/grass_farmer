defmodule GrassFarmer.PersistenceAdapter do
  alias GrassFarmer.Persist

  def new(params, module \\ from_env()) do
    adapter = module.__struct__(set_name: params.set_name, configs: params.configs)

    module.new(adapter)
  end

  def local_write(adapter), do: Persist.local_write(adapter)
  def local_read(adapter), do: Persist.local_read(adapter)
  def save(adapter), do: Persist.save(adapter)
  def load(adapter), do: Persist.load(adapter)

  defp from_env, do: Application.get_env(:grass_farmer, :persistence_adapter)
end
