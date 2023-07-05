defmodule GrassFarmerWeb.Components.Zones do
  use Phoenix.Component

  import GrassFarmerWeb.Components.StyleBlocks

  def list(assigns) do
  ~H"""
  <style>
      body {background:white !important;}
  </style>
  <div class="main flex flex-col m-4">
    <div class="header">
      <div class="text-xl font-bold text-gray-600 mb-2">Watering Zones</div>
    </div>
    <.zone_card zone={%{name: "Front Yard", number: 1, status: "on"}} />
    <.zone_card zone={%{name: "Front Yard", number: 2, status: "off"}} />
  </div>
  """
  end

  attr :zone, :map, required: true
  def zone_card(assigns) do
    ~H"""
      <div class={bg_color(@zone.status) <> " each flex hover:shadow-lg select-none p-2 rounded-md border-gray-300 border mb-1 hover:border-gray-500 cursor-pointer"}>
        <div class="left">
          <div >
            <span class="header text-blue-600 font-semibold text-lb"><%= @zone.name %></span>
            <span class="text-gray-600 font-semibold text-sm"><%= @zone.number %></span>
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
      _    -> "bg-gray-100"
    end
  end
end
