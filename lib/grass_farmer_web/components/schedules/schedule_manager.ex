defmodule GrassFarmerWeb.Components.ScheduleManager do
  use Phoenix.LiveComponent

  alias GrassFarmer.{Schedule, PersistenceAdapter, ScheduleZone}
  alias GrassFarmer.Zones.Zone
  import GrassFarmerWeb.Components.StyleBlocks
  import GrassFarmerWeb.CoreComponents

  @impl true
  def mount(socket) do
    {:ok, assign(socket, %{edit_schedule: "", delete_schedule: ""})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="mb-1 mx-3">
        <div class="flex">
          <h2 class="text-xl font-bold text-gray-600">Schedules</h2>
          <button class="text-xl font-bold ml-3" phx-click="create_schedule" phx-target={@myself} > + </button>
        </div>
        <div class="flex items-start">
          <%= for schedule <- @schedules do %>
            <div class="py-1 px-2 mr-2 rounded-md bg-green-100 hover:bg-yellow-100" phx-click="edit_schedule" phx-value-id={schedule.id} phx-target={@myself} ><%= schedule.name %></div>
            <%= if @edit_schedule == schedule.id  do %>
              <.schedule_modal_form myself={@myself} schedule={schedule} zones={@zones}/>
            <% end %>
            <%= if @delete_schedule == {schedule.id} do %>
              <.confirm_delete_modal myself={@myself} schedule={schedule} />
            <% end %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  attr :myself, :map, required: true
  attr :schedule, Schedule, required: true
  def confirm_delete_modal(assigns) do
    ~H"""
    <.modal_wrapper myself={@myself} entity={@schedule} form_title="Confirm Delete" allow_delete="no">
      <div class="py-5">
        <div class="pb-5">
          <span class="text-xl">Are you sure you want to delete <%= @schedule.name %>?</span>
        </div>
        <div class="flex justify-between">
          <.button class="text-xl ml-3 bg-zinc-300" phx-click="confirm_delete" phx-value-id={@schedule.id} phx-target={@myself}> Yes </.button>
          <.button class="text-xl font-bold ml-3 bg-green-600 hover:bg-green-800" phx-click="cancel_edit" phx-target={@myself} > No </.button>
        </div>
      </div>
    </.modal_wrapper>
    """
  end

  attr :myself, :map, required: true
  attr :schedule, Schedule, required: true
  attr :zones, :list, required: true
  def schedule_modal_form(assigns) do
    ~H"""
    <.modal_wrapper
        myself={@myself}
        entity={@schedule}
        form_title="Update Schedule"
        allow_delete="yes" >
      <form action="#" phx-submit="submit_schedule" phx-change="temp_update" phx-target={@myself}>
        <.modal_form myself={@myself}>
          <div class="py-5">
            <div class="pb-5">
              <input type="hidden" name="id" value={@schedule.id} />
              <label class="pr-5">Name</label><input type="text" name="name" value={@schedule.name} />
            </div>
            <label class="pr-5">Start Time</label>

            <select name="start_hour" >
              <%= for hour <- 1..12 do %>
                <%= if hour_match(hour, @schedule.start_time.hour) do %>
                  <option value={hour} selected><%= hour %></option>
                <% else %>
                  <option value={hour} ><%= hour %></option>
                <% end %>
              <% end %>
            </select>

            <span class="text-2xl font-bold">:</span>

            <select name="start_minute">
              <%= for minute <- 0..11 do %>
                <%= if minute * 5 == @schedule.start_time.minute do %>
                  <option value={minute * 5} selected label={two_digit(minute * 5)} />
                <% else %>
                  <option value={minute * 5} label={two_digit(minute * 5)} />
                <% end %>
              <% end %>
            </select>
            <span class="text-2xl font-bold">:</span>

            <select name="start_am_pm">
              <%= if @schedule.start_time.hour > 12 do %>
                <option value="AM" >AM</option>
                <option value="PM" selected >PM</option>
              <% else %>
                <option value="AM" selected >AM</option>
                <option value="PM" >PM</option>
              <% end %>
            </select>
          </div>
          <ul>
            <li class="flex justify-between p-3">
              <div>Zone Name</div>
              <div>Duration</div>
              <div>Valve Number</div>
            </li>
            <%= for zone <- @zones do %>
              <li class={zone_in_schedule_format(zone, @schedule.zones) <> " flex justify-between p-3"} phx-click="toggle_zone" phx-value-zone={zone.id} phx-value-schedule={@schedule.id} phx-target={@myself} >
                <div><%= zone.name %></div>
                <div><%= duration(zone, @schedule.zones) %></div>
                <div><%= zone.sprinkler_zone %></div>
              </li>
            <% end %>
          </ul>
        </.modal_form>
      </form>
    </.modal_wrapper>
    """
  end

  @impl true
  def handle_event("create_schedule", _params, socket) do
    schedule = %Schedule{id: Ecto.UUID.generate(), name: "New Schedule", zones: [], start_time: ~T[00:07:00]}

    { :noreply,
      assign(socket, %{schedules: ( socket.assigns.schedules ++ [schedule] ), edit_schedule: schedule.id})}
  end

  @impl true
  def handle_event("edit_schedule", params, socket) do
    { :noreply, assign(socket, %{edit_schedule: params["id"] }) }
  end

  @impl true
  def handle_event("submit_schedule", _params, socket) do
    schedules = socket.assigns.schedules

    write_schedules(schedules)

    {:noreply, assign(socket, %{schedules: schedules, edit_schedule: ""})}
  end

  @impl true
  def handle_event("temp_update", params, socket) do
    schedules =
      socket.assigns.schedules
      |> Enum.map(fn schedule ->
        if schedule.id == params["id"] do
          schedule
          |> convert_params(params)
          |> IO.inspect(label: "schedule temp_update after convert")
        else
          schedule
        end
      end)

    {:noreply, assign(socket, %{schedules: schedules})}
  end

  @impl true
  def handle_event("cancel_edit", _params, socket) do
    saved_schedules =
      PersistenceAdapter.new(%{set_name: "schedules", configs: nil})
      |> PersistenceAdapter.local_read
      |> Enum.filter(fn schedule -> schedule.id != nil end)

    { :noreply,
      assign(socket, %{schedules: saved_schedules, edit_schedule: ""}) }
  end

  @impl true
  def handle_event("toggle_zone", %{"schedule" => schedule_id, "zone" => zone_id}, socket) do

    new_schedules = 
      socket.assigns.schedules
      |> Enum.map(fn schedule ->
         IO.inspect(schedule, label: "schedule toggle_zone handle event before")
        if schedule.id == schedule_id do
          case schedule.zones do
            [] -> 
              Map.put(schedule, :zones, [%ScheduleZone{zone_id: zone_id, duration: 10}])
            _ -> 
              zone = Enum.find(schedule.zones, fn z -> z.zone_id == zone_id end)
              case zone do
                nil -> 
                  Map.put(schedule, :zones, schedule.zones ++ [%ScheduleZone{zone_id: zone_id, duration: 10}])
                _ -> 
                  Map.put(schedule, :zones, Enum.filter(schedule.zones, fn z -> z.zone_id != zone_id end))
              end
          end
        else
          schedule
        end
      end)
      |> IO.inspect(label: "new_schedules toggle_zone handle event")

    {:noreply, assign(socket, %{schedules: new_schedules})}
  end

  @impl true
  def handle_event("request_delete", params, socket) do
    schedules =
      socket.assigns.schedules
      |> Enum.map(fn schedule ->
        if schedule.id == params["id"] do
          Map.put(schedule, :edit, :delete)
        else
          schedule
        end
      end)
    {:noreply, assign(socket, %{schedules: schedules})}
  end

  @impl true
  def handle_event("confirm_delete", params, socket) do
    schedules =
      socket.assigns.schedules
      |> Enum.filter(fn schedule -> schedule.id != params["id"] end)

    write_schedules(schedules)

    {:noreply, assign(socket, %{schedules: schedules})}
  end

  @spec duration(%Zone{}, [%ScheduleZone{}]) :: Integer
  defp duration(zone, schedule_zones) do
    case schedule_zones do
      [] -> 0
      [nil] -> 0
      zones ->
        zones_found = Enum.find(zones, fn z -> z.zone_id == zone.id end)
        if zones_found == nil do
          0
        else
          Map.get(zones_found, :duration, 10)
        end
    end
  end

  def write_schedules(schedules) do
    PersistenceAdapter.new(%{set_name: "schedules", configs: schedules})
    |> PersistenceAdapter.local_write
    |> PersistenceAdapter.save
  end

  @spec convert_params(%Schedule{}, map()) :: %Schedule{}
  def convert_params(schedule, params) do
    hours =
      case {params["start_hour"] |> String.to_integer , params["start_am_pm"]} do
       {12, "AM"} -> 0 
       {12, "PM"} -> 12 
       {hour, "AM"} -> hour 
       {hour, "PM"} -> hour + 12
      end

    time = Time.new!(hours, String.to_integer(params["start_minute"]), 0)

    schedule
    |> Map.put(:name, params["name"])
    |> Map.put(:start_time, time)
  end

  @spec zone_in_schedule_format(Zone.t(), [:uuid]) :: String.t()
  defp zone_in_schedule_format(zone, schedule_zones) do
    zone_ids = schedule_zones |> Enum.map(&(&1.zone_id)) 
    if Enum.member?(zone_ids, zone.id) do
      "bg-green-200"
    else
      "bg-yellow-200"
    end
  end

end
