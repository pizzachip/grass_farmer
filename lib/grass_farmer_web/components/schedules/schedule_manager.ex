defmodule GrassFarmerWeb.Components.ScheduleManager do
  use Phoenix.LiveComponent

  alias GrassFarmer.{Schedule, Zone, PersistenceAdapter}

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="mb-1 mx-3">
        <div class="flex">
          <h2 class="text-xl font-bold text-gray-600">Schedules</h2>
          <button class="text-xl font-bold ml-3" phx-click="add_schedule" phx-target={@myself} >
            +
          </button>
        </div>
        <%= for schedule <- @schedules do %>
          <span style="px-4"><%= schedule.name %></span>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("add_schedule", _params, socket) do
    schedule_max_id =
        socket.assigns.schedules
        |> Enum.reduce(0, fn schedule, acc -> max(schedule.id, acc) end)

    schedules =
      socket.assigns.schedules ++ [%Schedule{id: schedule_max_id + 1, name: "New Schedule"}]

    PersistenceAdapter.new(%{set_name: "schedules", configs: schedules})
    |> PersistenceAdapter.local_write

    IO.inspect(assign(socket, %{schedules: schedules}))

    {:noreply, assign(socket, %{schedules: schedules})}
  end
end
