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
          <button class="text-xl font-bold ml-3" phx-click="create_schedule" phx-target={@myself} >
            +
          </button>
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
          <input type="hidden" name="id" value={@schedule.id} />

          <div><span>Schedule name</span>
          <input type="text" name="name" value={@schedule.name} />
          </div>
          <h3>Zones</h3>
          <%= for zone <- @zones do %>
            <p>
              <span><%= zone.name %></span>
              <span><%= zone.sprinkler_zone %></span>
            </p>
          <% end %>
        </.modal_form>
      </form>
    </.modal_wrapper>
    """
  end

  @impl true
  def handle_event("create_schedule", _params, socket) do
    schedule = %Schedule{name: "New Schedule", edit: true}

    { :noreply,
       assign(socket, %{schedules: socket.assigns.schedules ++ [schedule]})
    }
  end

  @impl true
  def handle_event("edit_schedule", params, socket) do

    {:noreply, socket}
  end

  @impl true
  def handle_event("submit_schedule", params, socket) do
    schedules =
      socket.assigns.schedules
      |> Enum.map(fn schedule ->
        if schedule.id == params["id"] |> String.to_integer do
          schedule
          |> convert_params(params)
          |> Map.merge(%{edit: false})
        else
          schedule
        end
      end)

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
  end

  @spec zone_name(integer(), list(Zone)) :: String.t()
  defp zone_name(sprinkler_zone, zones) do
    Enum.find_value(zones, fn zone -> zone.id == sprinkler_zone end, fn zone -> zone.name end)
  end

end
