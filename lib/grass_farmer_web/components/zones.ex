defmodule GrassFarmerWeb.Components.Zones do
  use Phoenix.LiveComponent

  import GrassFarmerWeb.Components.StyleBlocks

  @impl true
  def render(assigns) do
    ~H"""
    <div class="main flex flex-col h-full m-3">
      <div>
        <div class="header">
          <div class="text-xl font-bold text-gray-600 mb-2">Watering Zones</div>
        </div>
        <%= for zone <- @zones do %>
          <.zone_card zone={zone} />
        <% end %>
      </div>
      <div class="flex justify-end">
        <button class="rounded-full text-2xl font-bold bg-green-200 px-3 py-1" phx-click="add_zone">
          +
        </button>
      </div>
    </div>
    """
  end

  attr :zone, :map, required: true
  def zone_card(assigns) do
    ~H"""
    <div class={bg_color(@zone["status"]) <> " each flex hover:shadow-lg select-none p-2 rounded-md border-gray-300 border mb-1 hover:border-gray-500 cursor-pointer"}>
      <div class="left">
        <div>
          <span class="header text-blue-600 font-semibold text-lb"><%= @zone["name"] %></span>
          <span class="text-gray-600 font-semibold text-sm"><%= @zone["id"] %></span>
        </div>
      </div>
      <div class="right m-auto mr-0">
        <.edit_pencil />
      </div>
    </div>
    """
  end

  defp bg_color(status) do
    case status do
      "on" -> "bg-green-100"
      _ -> "bg-gray-100"
    end
  end
end
