defmodule GrassFarmerWeb.Components.ZoneManager do
  use Phoenix.LiveComponent

  import GrassFarmerWeb.Components.StyleBlocks

  alias GrassFarmer.{ Zone, PersistenceAdapter }
  alias Phoenix.PubSub

  @impl true
  def render(assigns) do
    ~H"""
    <div class="main flex flex-col h-full m-3">
      <div>
        <div class="header">
          <div class="text-xl font-bold text-gray-600 mb-2">Watering Zones</div>
        </div>
        <%= for zone <- @zones do %>
          <.zone_card zone={zone} myself={@myself} />
        <% end %>
      </div>
      <div class="flex justify-end">
        <button class="rounded-full text-2xl font-bold bg-green-200 px-3 py-1" phx-click="create_zone" phx-target={@myself}>
          +
        </button>
      </div>
    </div>
    """
  end

  attr :zone, :map, required: true
  attr :myself, :map, required: true
  def zone_card(assigns) do
    ~H"""
    <div class="each flex hover:shadow-lg select-none p-2 rounded-md border-gray-300 border mb-1 hover:border-gray-500 cursor-pointer">
      <div class="left">
        <%= if @zone.edit == true do %>
          <form action="#" phx-submit="update_zone" phx-target={@myself}>
            <input type="hidden" name="id" value={@zone.id} />
            <input type="text" name="zone_name" value={@zone.name} />
            <input type="text" name="sprinkler_zone" placeholder={@zone.sprinkler_zone} value={@zone.sprinkler_zone} class="w-12 text-center"/>
            <input type="submit" value="update" class="text-blue-500 cursor-pointer pl-4">
          </form>
        <% else %>
            <span class="header text-blue-600 font-semibold text-lb"><%= @zone.name %></span>
            <span class="text-gray-600 font-semibold text-sm"><%= @zone.sprinkler_zone %></span>
         <% end %>
      </div>

      <div class="right m-auto mr-0 flex space-x-4">
        <div phx-click="edit_zone" phx-value-zone={@zone.id} phx-target={@myself} >
          <.edit_pencil />
        </div>

        <div phx-click="delete_zone" phx-value-zone={@zone.id} phx-target={@myself} >
          <.delete />
        </div>
      </div>

    </div>
    """
  end

  @impl true
  def handle_event("create_zone", _params, socket) do
    next_sprinkler_zone =
      socket.assigns.zones
      |> Enum.reduce(0, fn zone, acc -> max(zone.sprinkler_zone, acc) end)

    zones = socket.assigns.zones ++ [%Zone{id: Ecto.UUID.generate(), sprinkler_zone: next_sprinkler_zone + 1, edit: true}]

    PersistenceAdapter.new(%{set_name: "zones", configs: zones})
    |> PersistenceAdapter.local_write
    |> PersistenceAdapter.save

    {:noreply, assign(socket, %{zones: zones})}
  end

  @impl true
  def handle_event("update_zone", params, socket) do
    new_zones =
      socket.assigns.zones
      |> Enum.map(fn zone -> if zone.id == params["id"], do: %Zone{zone | name: params["zone_name"], edit: false}, else: zone end)

    PersistenceAdapter.new(%{set_name: "zones", configs: new_zones})
     |> PersistenceAdapter.local_write
     |> PersistenceAdapter.save

    PubSub.broadcast(GrassFarmer.PubSub, "assigns", {:update_zones, new_zones})

    {:noreply, assign(socket, %{zones: new_zones})}
  end

  @impl true
  def handle_event("edit_zone", %{"zone" => zone_id}, socket) do
    new_zones =
      socket.assigns.zones
      |> Enum.map(fn zone -> if zone.id == zone_id, do: %{zone | edit: true}, else: zone end)

    PersistenceAdapter.new(%{set_name: "zones", configs: new_zones})
    |> PersistenceAdapter.local_write

    {:noreply,
     assign(socket, %{zones: new_zones})}
  end

  @impl true
  def handle_event("delete_zone", %{"zone" => zone_id}, socket) do
    new_zones =
      socket.assigns.zones
      |> Enum.filter(fn zone -> zone.id != zone_id end)

    PersistenceAdapter.new(%{set_name: "zones", configs: new_zones})
    |> PersistenceAdapter.local_write
    |> PersistenceAdapter.save

    PubSub.broadcast(GrassFarmer.PubSub, "assigns", {:update_zones, new_zones})

    {:noreply, assign(socket, %{zones: new_zones})}
  end

end
