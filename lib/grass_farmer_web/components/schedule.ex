defmodule GrassFarmerWeb.Components.Schedule do
  use Phoenix.Component

  import GrassFarmerWeb.Components.StyleBlocks

  def quickview(assigns) do
    ~H"""
    <div class="mb-1 mx-1">
      <.tile_row_wrapper>
        <.info_tile>
          <.last_icon />
          <.tile_text copy={%{title: "Last Watering", text: "Thu 24 Jul"}} />
        </.info_tile>
        <.info_tile>
          <.next_icon />
          <.tile_text copy={%{title: "Next", text: "Sat 26 Jul"}} />
        </.info_tile>
      </.tile_row_wrapper>
    </div>
    """
  end

  attr :schedules, :list, required: true
  def list(assigns) do
    ~H"""
      <div class="mb-1 mx-3">
        <div class="flex">
          <h2 class="text-xl font-bold text-gray-600">Schedules</h2>
          <button class="text-xl font-bold ml-3" phx-click="add_schedule" >
            +
          </button>
        </div>
        <%= for schedule <- @schedules do %>
          <span style="px-4"><%= schedule.name %></span>
        <% end %>
      </div>
    """
  end
end
