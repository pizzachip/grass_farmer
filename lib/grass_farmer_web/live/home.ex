defmodule GrassFarmerWeb.Home do
  use GrassFarmerWeb, :live_view
  alias GrassFarmerWeb.Components.{Schedule, Weather, Zones, Footer, StyleBlocks}
  alias GrassFarmer.Zone
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    PubSub.subscribe(GrassFarmer.PubSub, "time_keeper")

    new_socket =
      assign(
        socket,
        %{
          time_left: "0",
          watering_status: "off",
          time: StyleBlocks.time_format(NaiveDateTime.local_now(), :just_time),
          zones: [%Zone{id: 1}]
        }
      )

    {:ok, new_socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.page_title title="Suburban Grass Farmer" />
    <.body>
      <div class="flex flex-col h-full justify-between">
        <div>
          <Schedule.quickview />
          <Weather.quickview />
          <.live_component module={Zones} id="zones" zones={@zones} />
        </div>
        <div>
          <Footer.controls watering_status={@watering_status} time_left={@time_left} />
        </div>
      </div>
    </.body>
    """
  end

  @impl true
  def handle_event("add_zone", _params, socket) do
    zone_max_id = socket.assigns.zones |> Enum.reduce(0, fn zone, acc -> max(zone.id, acc) end)
    {:noreply, assign(socket, %{zones: [%Zone{id: zone_max_id + 1} | socket.assigns.zones]})}
  end

  @impl true
  def handle_info({:update_time, time}, socket) do
    time_formatted = StyleBlocks.time_format(time, :just_time)
    {:noreply, assign(socket, %{time: time_formatted})}
  end
end
