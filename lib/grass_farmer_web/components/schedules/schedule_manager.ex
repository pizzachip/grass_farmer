defmodule GrassFarmerWeb.Components.ScheduleManager do
  use Phoenix.LiveComponent

  alias GrassFarmer.{Schedule, Zone, PersistenceAdapter}
  import Ecto.Changeset
  import GrassFarmerWeb.Components.StyleBlocks

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
            <select name="start_hour">
              <%= for hour <- 0..12 do %>
                <option value={hour} ><%= hour %></option>
              <% end %>
            </select>
            <select name="start_minute">
              <%= for minute <- 0..12 do %>
                <option value={minute * 5} ><%= minute * 5 %></option>
              <% end %>
            </select>
            <select name="start_am_pm">
                <option value="AM" >AM</option>
                <option value="PM" >PM</option>
            </select>
          </div>
          <ul>
            <%= for zone <- @zones do %>
              <li class="flex justify-between">
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

    {
      :noreply,
      assign(socket, %{schedules: updated_list})
    }
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
        else
          schedule
        end
      end)
      |> IO.inspect(label: "schedules")

    PersistenceAdapter.new(%{set_name: "schedules", configs: schedules})
    |> PersistenceAdapter.local_write
    |> PersistenceAdapter.save

    {:noreply, assign(socket, %{schedules: schedules})}
  end

  @impl true
  def handle_event("cancel_edit", _params, socket) do
    updated_list =
      socket.assigns.schedules
      |> Enum.map(fn schedule -> Map.put(schedule, :edit, false) end)
      |> Enum.filter(fn schedule -> schedule.id != nil end)

    {
      :noreply,
      assign(socket, %{schedules: updated_list})
    }
  end

  @spec convert_params(%Schedule{}, map()) :: %Schedule{}
  def convert_params(schedule, params) do
    Schedule.changeset(schedule, params)
    |> apply_changes
    |> IO.inspect(label: "schedule - changes applied")
  end

  @spec zone_name(integer(), list(Zone)) :: String.t()
  defp zone_name(sprinkler_zone, zones) do
    Enum.find_value(zones, fn zone -> zone.id == sprinkler_zone end, fn zone -> zone.name end)
  end

end
