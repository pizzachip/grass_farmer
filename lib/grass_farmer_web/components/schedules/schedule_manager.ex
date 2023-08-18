defmodule GrassFarmerWeb.Components.ScheduleManager do
  use Phoenix.LiveComponent

  alias GrassFarmer.{Schedule}
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
            <.schedule_modal_form myself={@myself} schedule={schedule} />
          <% end %>
        <% end %>
      </div>

    </div>
    """
  end

  attr :myself, :map, required: true
  attr :schedule, Schedule, required: true
  def schedule_modal_form(assigns) do
    ~H"""
    <.modal_wrapper myself={@myself} schedule={@schedule}  form_title="Create New Schedule" >
      <form action="#" phx-submit="submit_schedule" phx-target={@myself}>
        <.modal_form myself={@myself}>
          <input type="hidden" name="id" value={@schedule.id} />

          <div><span>Schedule name</span>
          <input type="text" name="name" value={@schedule.name} />
          </div>

          <%= for zone <- @schedule.zones do %>
            <input type="text" name="zone_id" value={zone["sprinkler_zone"]} />
            <input type="number" name="duration" value={zone["duration"]} />
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
       assign(socket, %{schedules: socket.assigns.schedules ++ [schedule]} |> IO.inspect(label: "created schedule"))
    }
  end

  @impl true
  def handle_event("edit_schedule", params, socket) do
    new_schedules =
      socket.assigns.schedules
      |> Enum.map(fn schedule ->
        if schedule.id == params["id"] |> String.to_integer do
          Map.put(schedule, :edit, true)
        else
          Map.put(schedule, :edit, false)
        end
      end)
    {:noreply, assign(socket, %{schedules: new_schedules})}
  end

  @impl true
  def handle_event("submit_schedule", params, socket) do
    IO.inspect(params, label: "params")
    IO.inspect(socket.assigns.schedules, label: "schedules")

    convert_params(params, socket.assigns.schedules)
    |> IO.inspect(label: "schedules")

    {:noreply, socket}
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

  @spec convert_params(map(), %Schedule{}) :: %Schedule{}
  defp convert_params(params, schedule) do
    struct(schedule,
      %{
          name: params["name"],
          start_time: params["start_time"],
          zones: [], #TODO load from params
          days: params["days"],
          edit: false,
          status: :off
      } |> Enum.filter(fn {_k,v} -> v != nil end)
    )
  end

end
