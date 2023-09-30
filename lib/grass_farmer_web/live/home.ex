defmodule GrassFarmerWeb.Home do
  use GrassFarmerWeb, :live_view

  alias GrassFarmerWeb.Components.{ScheduleTiles,
    ScheduleManager,
    Weather,
    ZoneManager,
    Footer,
    StyleBlocks}
  alias GrassFarmer.Schedules.Schedule
  alias GrassFarmer.Loader
  alias GrassFarmer.Zones.Zone

  @impl true
  def mount(_params, _session, socket) do
    new_socket =
      assign(socket,
        Loader.translate()
        |> Map.merge(
          %{time: NaiveDateTime.local_now(),
            edit_zone: "",
            edit_schedule: "",
            delete_schedule: ""
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
          <ScheduleTiles.quickview />
          <Weather.quickview />
          <.live_component module={ScheduleManager} id="schedules" zones={@zones} schedules={@schedules} edit_schedule={@edit_schedule}, delete_schedule={@delete_schedule} />
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
      {:noreply, assign(socket, %{zones: Zone.create_zone(socket.assigns.zones)})}
  end

  @impl true
  def handle_event("manage_zones", %{"action" => "delete", "zone_id" => zone_id}, socket) do
      { zones, schedules } = Zone.delete_zone(socket.assigns.zones, socket.assigns.schedules, zone_id)
      {:noreply, assign(socket, %{zones: zones, schedules: schedules})}
  end

  @impl true
  def handle_event("manage_zones",  %{"action" => "update", "id"=> zone_id, "zone_name" => name, "sprinkler_zone" => sprinkler_zone }, socket) do
    {:noreply,  
     assign(socket,  
       %{zones: Zone.update_zone(socket.assigns.zones, {zone_id, name, sprinkler_zone }),
       edit_zone: ""})
    }
  end

  @impl true
  def handle_event("manage_schedules", %{"action" => "create"}, socket) do
    { schedules, schedule_id } = Schedule.create_schedule(socket.assigns.schedules)
    IO.inspect(schedules, label: "schedules create event home")

    {:noreply,  assign(socket, %{schedules: schedules, edit_schedule: schedule_id}) }
  end

  @impl true
  def handle_event("manage_schedules", %{ "action" => "edit_schedule", "id" => id }, socket) do
    { :noreply, assign(socket, %{edit_schedule: id }) }
  end


  @impl true
  def handle_event("manage_schedules", %{"action" => "request_delete", "id" => id}, socket) do
    {:noreply, assign(socket, %{delete_schedule: id})}
  end

  @impl true
  def handle_event("manage_schedules", %{ "action" => "delete", "id" => id}, socket) do
    {:noreply, 
      assign(socket, %{schedules: Schedule.delete(socket.assigns.schedules, id)})
    }
  end

  @impl true
  def handle_event("manage_schedules", %{"action" => "toggle_zone", "zone" => zone_id, "schedule" => schedule_id}, socket) do
    {:noreply, 
      assign(socket, %{schedules: Schedule.toggle_zone(schedule_id, zone_id, socket.assigns.schedules)})
    }
  end

  @impl true
  def handle_event("manage_schedules", %{"action" => "cancel_edit"}, socket) do
    { :noreply,
      assign(socket, %{schedules: Schedule.get_schedules(), edit_schedule: ""}) }
  end

  @impl true
  def handle_event("manage_schedules", %{"action" => "toggle_day", "schedule" => schedule_id, "day" => day}, socket) do
    {:noreply, 
      assign(socket, %{schedules: Schedule.toggle_day(socket.assigns.schedules, schedule_id, day |> String.to_integer)})
    }
  end

  @impl true
  def handle_event("update_zone_duration", %{"schedule" => schedule_id, 
    "zone" => zone_id,
    "duration" => duration}, socket) do

    new_schedules =
      socket.assigns.schedules
      |> Enum.map( fn schedule ->
        if schedule.id == schedule_id do
           %{schedule | zones: Enum.map(schedule.zones, fn zone ->
             if zone.zone_id == zone_id do
               %{zone | duration: duration |> String.to_integer}
             else
               zone
             end
           end)}
        else
          schedule
        end
      end) 
    {:noreply, assign(socket, %{schedules: new_schedules})}
  end

  @impl true
  def handle_event("submit_schedule", _params, socket) do
    IO.inspect(socket.assigns.schedules, label: "submit_schedule")
    Schedule.write_schedules(socket.assigns.schedules)

    {:noreply, assign(socket, %{edit_schedule: ""}) }
  end

  @impl true
  def handle_event("temp_update", params, socket) do
    schedules = Schedule.temp_update(socket.assigns.schedules, params)

    {:noreply, assign(socket, %{schedules: schedules, edit_schedule: params["id"]}) }
  end

  @impl true
  def handle_info({:update_time, time}, socket) do
    time_formatted = StyleBlocks.time_format(time, :just_time)
    {:noreply, assign(socket, %{time: time_formatted})}
  end

end
