defmodule GrassFarmerWeb.Components.Zones do
  use Phoenix.LiveComponent

  import GrassFarmerWeb.Components.StyleBlocks

  alias GrassFarmer.{ Zone, PersistenceAdapter }

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
        <button class="rounded-full text-2xl font-bold bg-green-200 px-3 py-1" phx-click="add_zone" phx-target={@myself}>
          +
        </button>
      </div>
    </div>
    """
  end

  attr :zone, :map, required: true
  def zone_card(assigns) do
    ~H"""
    <div class={bg_color(@zone.status) <> " each flex hover:shadow-lg select-none p-2 rounded-md border-gray-300 border mb-1 hover:border-gray-500 cursor-pointer"}>
      <div class="left">
        <%= if @zone.edit == true do %>
          <form action="#" phx-submit="update_zone">
            <input type="text" name="zone_name" placeholder={@zone.name} />
            <input type="text" name="zone_id" placeholder={@zone.id} value={@zone.id} class="w-12 text-center"/>
            <input type="submit" value="update" class="text-blue-500 cursor-pointer pl-4">
          </form>
        <% else %>
            <span class="header text-blue-600 font-semibold text-lb"><%= @zone.name %></span>
            <span class="text-gray-600 font-semibold text-sm"><%= @zone.id %></span>
         <% end %>
      </div>

      <div class="right m-auto mr-0 flex space-x-4">
        <div phx-click="edit_zone" phx-value-zone={@zone.id} >
          <.edit_pencil />
        </div>

        <div phx-click="delete_zone" phx-value-zone={@zone.id} >
          <.delete />
        </div>
      </div>

    </div>
    """
  end

  @impl true
  def handle_event("add_zone", _params, socket) do
    zone_max_id =
      socket.assigns.zones
      |> Enum.reduce(0, fn zone, acc -> max(zone.id, acc) end)

    zones = socket.assigns.zones ++ [%Zone{id: zone_max_id + 1}]

    PersistenceAdapter.new(%{set_name: "zones", configs: zones})
    |> PersistenceAdapter.local_write

    {:noreply, assign(socket, %{zones: zones})}
  end

  defp bg_color(status) do
    case status do
      "on" -> "bg-green-100"
      _ -> "bg-gray-100"
    end
  end
end
