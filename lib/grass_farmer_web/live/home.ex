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
  def handle_event("update_zone", params, socket) do
    new_zones =
      socket.assigns.zones
      |> Enum.map(fn zone -> if zone.id == (params["zone_id"] |> String.to_integer), do: %Zone{zone | name: params["zone_name"], id: params["zone_id"], edit: false}, else: zone end)

    PersistenceAdapter.new(%{set_name: "zones", configs: new_zones})
     |> PersistenceAdapter.local_write

    {:noreply, assign(socket, %{zones: new_zones})}
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
