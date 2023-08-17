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
    <.modal_wrapper myself={@myself} schedule={@schedule}>
      <.modal_form myself={@myself} form_title="Create New Schedule">
        <div class="flex flex-col px-6 py-5 bg-gray-50">
          <.form  phx-submit="submit_schedule">
            <input type="text" />
            <button type="submit">Submit</button>
          </.form>
        </div>
      </.modal_form>
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

  def handle_event("submit_schedule", params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel_edit", params, socket) do
    updated_list =
      socket.assigns.schedules
      |> Enum.map(fn schedule -> Map.put(schedule, :edit, false) end)
      |> Enum.filter(fn schedule -> schedule.id != nil end)

    {
      :noreply,
      assign(socket, %{schedules: updated_list})
    }
  end

end
