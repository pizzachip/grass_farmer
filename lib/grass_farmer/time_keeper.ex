defmodule GrassFarmer.TimeKeeper do
  use GenServer

  alias Phoenix.PubSub

  @delay 15_000
  @defaults %{current_time: NaiveDateTime.local_now()}

  def start_link(opts \\ @defaults) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(state) do
    GenServer.cast(__MODULE__, :get_time)
    {:ok, state}
  end

  @impl true
  def handle_cast(:get_time, state) do
    Process.sleep(@delay)
    time = NaiveDateTime.local_now()
    PubSub.broadcast(GrassFarmer.PubSub, "time_keeper", {:update_time, time})
    GenServer.cast(__MODULE__, :get_time)
    {:noreply, state}
  end
end
