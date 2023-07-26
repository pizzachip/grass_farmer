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
        Loader.translate() |> Map.merge(%{time: NaiveDateTime.local_now()})
      )
      |> IO.inspect(label: "new_socket")

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
          <.live_component module={Footer}  id="footer" zones={@zones} />
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

    zones = socket.assigns.zones ++ [%Zone{id: zone_max_id + 1}]

    PersistenceAdapter.new(%{set_name: "zones", configs: zones})
    |> PersistenceAdapter.local_write

    {:noreply, assign(socket, %{zones: zones})}
  end

  @impl true
  def handle_event("edit_zone", %{"zone" => zone_id}, socket) do
    new_zones =
      socket.assigns.zones
      |> Enum.map(fn zone -> if zone.id == (zone_id |> String.to_integer), do: %{zone | edit: true}, else: zone end)

    PersistenceAdapter.new(%{set_name: "zones", configs: new_zones})
    |> PersistenceAdapter.local_write

    {:noreply,
     assign(socket, %{zones: new_zones})}

  end

  @impl true
  def handle_event("delete_zone", %{"zone" => zone_id}, socket) do
    new_zones =
      socket.assigns.zones
      |> Enum.filter(fn zone -> zone.id != (zone_id |> String.to_integer) end)

    PersistenceAdapter.new(%{set_name: "zones", configs: new_zones})
    |> PersistenceAdapter.local_write

    {:noreply,
     assign(socket, %{zones: new_zones})}
  end

  @impl true
  def handle_info({:update_time, time}, socket) do
    time_formatted = StyleBlocks.time_format(time, :just_time)
    {:noreply, assign(socket, %{time: time_formatted})}
  end

end
