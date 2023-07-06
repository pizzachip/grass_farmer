defmodule GrassFarmerWeb.Home do
  use GrassFarmerWeb, :live_view
  alias GrassFarmerWeb.Components.{Schedule, Weather, Zones, Footer}
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    PubSub.subscribe(GrassFarmer.PubSub, "time_keeper")
    new_socket =
      assign(socket,
        %{time_left: "1",
          watering_status: "off",
          time: NaiveDateTime.local_now()}
      )

    {:ok, new_socket }
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
            <Zones.list />
          </div>
          <div>
            <Footer.controls watering_status={@watering_status} time_left={@time_left} />
          </div>
        </div>
      </.body>
    """
  end

  @impl true
  def handle_info({:update_time, time}, socket) do
    {:noreply, assign(socket, %{time: time})}
  end

end
