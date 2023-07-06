defmodule GrassFarmerWeb.Components.Footer do
  use Phoenix.Component

  import GrassFarmerWeb.Components.StyleBlocks

  attr :watering_status, :string, required: true
  attr :time_left, :string
  def controls(assigns) do
    ~H"""
    <div class="flex place-content-between w-full bg-white p-3">
      <div class="flex">
        <.left_button status={@watering_status} time_left={@time_left} />
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

  attr :time_left, :string, required: true
  attr :status, :string, required: true
  def left_button(assigns) do
    ~H"""
    <button class="bg-blue-300 hover:bg-blue-400 text-gray-800 font-bold py-2 px-4 rounded inline-flex items-center">

      <%= button_text(@status) %>
      <.button_inset status = {@status}> <%= @time_left %></.button_inset>
    </button>
    """
  end

  def button_text(status) do
    case status do
      "on"  -> "Stop"
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
