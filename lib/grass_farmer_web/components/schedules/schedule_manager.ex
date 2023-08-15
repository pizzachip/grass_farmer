defmodule GrassFarmerWeb.Components.ScheduleManager do
  use Phoenix.LiveComponent

  alias GrassFarmer.{Schedule}
  import Ecto.Changeset

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
            <.schedule_modal_form myself={@myself} />
          <% end %>
        <% end %>
      </div>

    </div>
    """
  end

  attr :myself, :map, required: true
  def schedule_modal_form(assigns) do
    ~H"""
      <div class="flex justify-center h-screen w-screen top-0 left-0 fixed items-center bg-green-200/75 antialiased" phx-click="cancel_edit" phx-target={@myself}>
      <div class="flex flex-col w-11/12 sm:w-5/6 lg:w-1/2 max-w-2xl mx-auto rounded-lg border border-gray-300 shadow-xl" phx-click="" phx-target={@myself}>
        <div
          class="flex flex-row justify-between p-6 bg-white border-b border-gray-200 rounded-tl-lg rounded-tr-lg"
        >
          <p class="font-semibold text-gray-800">Add a schedule</p>
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" phx-click="cancel_edit" phx-target={@myself}>
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </div>
        <div class="flex flex-col px-6 py-5 bg-gray-50">
          <p class="mb-2 font-semibold text-gray-700">Name</p>
          <text
            type="text"
            name=""
            class="p-5 mb-5 bg-white border border-gray-200 rounded shadow-sm h-36"
            id=""
          ></text>
          <div class="flex flex-col sm:flex-row items-center mb-5 sm:space-x-5">
            <h2>Select Zones</h2>
          </div>
          <hr />
        </div>
        <div
          class="flex flex-row items-center justify-between p-5 bg-white border-t border-gray-200 rounded-bl-lg rounded-br-lg"
        >
          <p class="font-semibold text-gray-600">Cancel</p>
          <button class="px-4 py-2 text-white font-semibold bg-blue-500 rounded">
            Save
          </button>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("create_schedule", _params, socket) do
    case Schedule.changeset(%Schedule{}, %{name: "New Schedule", edit: true}) do
      %{valid?: true} = changeset ->
        schedule =
          apply_changes(changeset)
          |> Map.put(:id, Ecto.UUID.generate())

        { :noreply,
           assign(socket, %{schedules: socket.assigns.schedules ++ [schedule]})
        }

      _ ->
        {:noreply, assign(socket, %{edit: false}) |> IO.inspect(label: "assigns fail")}
    end
  end

  def handle_event("edit_schedule", params, socket) do
    new_schedules =
      socket.assigns.schedules
      |> Enum.map(fn schedule ->
        if schedule.id == params["id"] do
          Map.put(schedule, :edit, true)
        else
          Map.put(schedule, :edit, false)
        end
      end)
    {:noreply, assign(socket, %{schedules: new_schedules})}
  end

  @impl true
  def handle_event("cancel_edit", _params, socket) do
    {:noreply, assign(socket, %{edit: false})}
  end
end
