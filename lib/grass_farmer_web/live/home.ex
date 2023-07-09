defmodule GrassFarmerWeb.Home do
  use GrassFarmerWeb, :live_view
  alias GrassFarmerWeb.Components.{Schedule, Weather, Zones, Footer, StyleBlocks}
  alias GrassFarmer.{ Zone, PersistenceAdapter, Loader }
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    Loader.load()
    PubSub.subscribe(GrassFarmer.PubSub, "time_keeper")

    new_socket =
      assign(socket,
        Loader.translate() |> Map.merge(%{time: "00:00"})
      )

    {:ok, new_socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.page_title title="Suburban Grass Farmer" />
    <.body>
      <div class="flex flex-col h-full justify-between">
        <div>
          <Schedule.quickview />
          <Weather.quickview />
          <Schedule.list schedules={@schedules}/>
          <.live_component module={Zones} id="zones" zones={@zones} />
        </div>
        <div>
          <Footer.controls />
        </div>
      </div>
    </.body>
    """
  end

  @impl true
  def handle_event("add_zone", _params, socket) do
    zone_max_id =
      socket.assigns.zones
      |> Enum.reduce(0, fn zone, acc -> max(zone.id, acc) end)
      |> IO.inspect(label: "zone_max_id")

    zones = socket.assigns.zones ++ [%Zone{id: zone_max_id + 1}]

    PersistenceAdapter.new(%{set_name: "zones", configs: zones})
    |> IO.inspect(label: "new adapter")
    |> PersistenceAdapter.local_write

    {:noreply, assign(socket, %{zones: zones})}
  end

  @impl true
  def handle_info({:update_time, time}, socket) do
    time_formatted = StyleBlocks.time_format(time, :just_time)
    {:noreply, assign(socket, %{time: time_formatted})}
  end
end
