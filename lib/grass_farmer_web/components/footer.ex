defmodule GrassFarmerWeb.Components.Footer do
  use Phoenix.LiveComponent

  import GrassFarmerWeb.Components.StyleBlocks

  def render(assigns) do
    ~H"""
    <div class="flex place-content-between w-full bg-white p-3">
      <div class="flex">
        <.left_button status={watering_status(@schedules)} time_left={time_left(@schedules)} />
        <%= if assigns[:watering_status]=="off" do %>
          <.time_control />
        <% end %>
      </div>
      <%= if assigns[:watering_status]=="on" do %>
        <.stop_button />
      <% end %>
    </div>
    """
  end

  defp watering_status(schedules) do
    running_schedules = Enum.filter(schedules, fn schedule -> schedule.status == "on" end)

    case Enum.count(running_schedules) do
      0 -> "off"
      _ -> "on"
    end
  end

  defp time_left(_schedules) do
    # Need to move data structure to schedule event - drive from GenServer
    0
  end

  attr :time_left, :string, required: true
  attr :status, :string, required: true

  def left_button(assigns) do
    ~H"""
    <button class="bg-blue-300 hover:bg-blue-400 text-gray-800 font-bold py-2 px-4 rounded inline-flex items-center">
      <%= button_text(@status) %>
      <.button_inset status={@status}><%= @time_left %></.button_inset>
    </button>
    """
  end

  def button_text(status) do
    case status do
      "on" -> "Stop"
      "off" -> "Start"
    end
  end

  def time_control(assigns) do
    ~H"""
    <div class="p-1 text-2xl font-bold">
      <button class="pl-4">+</button>
      <button class="pl-4">-</button>
    </div>
    """
  end

  def stop_button(assigns) do
    ~H"""
    <button class="bg-red-300 hover:bg-red-400 text-gray-800 font-bold py-2 px-4 rounded inline-flex items-center">
      Stop
    </button>
    """
  end
end
