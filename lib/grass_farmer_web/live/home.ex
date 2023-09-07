defmodule GrassFarmerWeb.Home do
  use GrassFarmerWeb, :live_view

  alias GrassFarmerWeb.Components.{Schedule,
    ScheduleManager,
    Weather,
    ZoneManager,
    Footer,
    StyleBlocks}
  alias GrassFarmer.Loader
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    PubSub.subscribe(GrassFarmer.PubSub, "assigns")

    new_socket =
      assign(socket,
        Loader.translate()
        |> Map.merge(
          %{time: NaiveDateTime.local_now(),
            edit_zone: ""
          })
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
          <.live_component module={ScheduleManager} id="schedules" zones={@zones} schedules={@schedules} />
          <.live_component module={ZoneManager} id="zones" zones={@zones} edit_zone={@edit_zone} />
        </div>
        <div>
          <.live_component module={Footer}  id="footer" zones={@zones} schedules={@schedules} />
        </div>
      </div>
    </.body>
    """
  end

  @impl true
  def handle_event("manage_zones", %{"action" => "create"}, socket) do
      {:noreply, assign(socket, %{zones: ZoneManager.create_zone(socket.assigns.zones)})}
  end

  @impl true
  def handle_event("manage_zones", %{"action" => "delete", "zone_id" => zone_id}, socket) do
      {:noreply, assign(socket, %{zones: ZoneManager.delete_zone(socket.assigns.zones, zone_id)})}
  end

  @impl true
  def handle_info({:update_time, time}, socket) do
    time_formatted = StyleBlocks.time_format(time, :just_time)
    {:noreply, assign(socket, %{time: time_formatted})}
  end

  @impl true
  def handle_info({:update_zones, zones}, socket) do
    IO.inspect(socket.assigns.zones, label: "handle_info zones")
    {:noreply, assign(socket, %{zones: zones})}
  end

end
