defmodule GrassFarmerWeb.Components.ScheduleManager do
  use Phoenix.LiveComponent

  alias GrassFarmer.{Schedule, Zone, PersistenceAdapter}
  import Ecto.Changeset
  import GrassFarmerWeb.Components.StyleBlocks
  import Phoenix.HTML

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="mb-1 mx-3">
        <div class="flex">
          <h2 class="text-xl font-bold text-gray-600">Schedules</h2>
          <button class="text-xl font-bold ml-3" phx-click="create_schedule" phx-target={@myself} > + </button>
        </div>
        <%= for schedule <- @schedules do %>
          <span style="px-4" phx-click="edit_schedule" phx-value-id={schedule.id} phx-target={@myself} ><%= schedule.name %></span>
          <%= if schedule.edit == true do %>
            <.schedule_modal_form myself={@myself} schedule={schedule} zones={@zones}/>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end

  attr :myself, :map, required: true
  attr :schedule, Schedule, required: true
  attr :zones, :list, required: true
  def schedule_modal_form(assigns) do
    ~H"""
    <.modal_wrapper myself={@myself} schedule={@schedule}  form_title="Update Schedule" >
      <form action="#" phx-submit="submit_schedule" phx-target={@myself}>
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

            <select name="start_minute">
              <%= for minute <- 0..12 do %>
                <%= if minute * 5 == @schedule.start_time.minute do %>
                  <option value={minute * 5} selected ><%= minute * 5 %></option>
                <% else %>
                  <option value={minute * 5} ><%= minute * 5 %></option>
                <% end %>
              <% end %>
            </select>

            <select name="start_am_pm">
                <option value="AM" >AM</option>
                <option value="PM" >PM</option>
            </select>
          </div>
          <ul>
            <%= for zone <- @zones do %>
              <li class={zone_in_schedule_format(zone, @schedule.zones) <> " flex justify-between p-3"} phx-click="activate_zone" phx-value-zone={zone.id} phx-value-schedule={@schedule.id} phx-target={@myself} >
                <div><%= zone.name %></div>
                <div>Sprinkler <%= zone.sprinkler_zone %></div>
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
    schedule = %Schedule{id: Ecto.UUID.generate(), name: "New Schedule", edit: true}

    { :noreply,
       assign(socket, %{schedules: socket.assigns.schedules ++ [schedule]})
    }
  end

  @impl true
  def handle_event("edit_schedule", params, socket) do
    updated_list =
      socket.assigns.schedules
      |> Enum.map(fn schedule ->
          Map.put(schedule, :edit, schedule.id == params["id"])
        end)
      |> Enum.filter(fn schedule -> schedule.id != nil end)

    { :noreply,
      assign(socket, %{schedules: updated_list}) }
  end

  @impl true
  def handle_event("submit_schedule", params, socket) do
    schedules =
      socket.assigns.schedules
      |> Enum.map(fn schedule ->
        if schedule.id == params["id"] do
          schedule
          |> convert_params(params)
          |> Map.merge(%{edit: false})
          |> IO.inspect(label: "schedule - after merge")
        else
          schedule
        end
      end)

    write_schedules(schedules)

    {:noreply, assign(socket, %{schedules: schedules})}
  end

  @impl true
  def handle_event("cancel_edit", _params, socket) do
    updated_list =
      socket.assigns.schedules
      |> Enum.map(fn schedule -> Map.put(schedule, :edit, false) end)
      |> Enum.filter(fn schedule -> schedule.id != nil end)

    { :noreply,
      assign(socket, %{schedules: updated_list}) }
  end

  @impl true
  def handle_event("activate_zone", params, socket) do
    schedules =
      socket.assigns.schedules
      |> Enum.map(fn schedule ->
        if schedule.id == params["schedule"] do
          schedule
          |> activate_zone(%Zone{id: params["zone"]})
        else
          schedule
        end
      end)

    {:noreply, assign(socket, %{schedules: schedules})}
  end

  @spec activate_zone(%Schedule{}, %Zone{}) :: %Schedule{}
  def activate_zone(schedule, zone) do
    schedule
    |> Map.update!(:zones, fn zones ->
        zones ++ [zone.id]
        |> Enum.uniq
      end)
  end

  def write_schedules(schedules) do
    PersistenceAdapter.new(%{set_name: "schedules", configs: schedules})
    |> PersistenceAdapter.local_write
    |> PersistenceAdapter.save
  end

  @spec convert_params(%Schedule{}, map()) :: %Schedule{}
  def convert_params(schedule, params) do
    add_12 =
      if params["start_am_pm"] == "PM" do
        1
      else
        0
      end

    hours = String.to_integer(params["start_hour"]) + 12 * add_12 |> IO.inspect(label: "hours")

    time = Time.new!(hours, String.to_integer(params["start_minute"]), 0)

    Schedule.changeset(schedule, params |> Map.put("start_time", time))
    |> apply_changes
    |> IO.inspect(label: "schedule - changes applied")
  end

  @spec zone_in_schedule_format(%Zone{}, [:uuid]) :: String.t()
  defp zone_in_schedule_format(zone, schedule_zones) do
    if Enum.member?(schedule_zones, zone.id) do
      "bg-green-200"
    else
      "bg-yellow-200"
    end
  end

end
