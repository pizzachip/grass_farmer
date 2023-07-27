defmodule GrassFarmerWeb.Home do
  use GrassFarmerWeb, :live_view

  alias GrassFarmerWeb.Components.{Schedule, Weather, Zones, Footer, StyleBlocks}
  alias GrassFarmer.Loader
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    Loader.load()
    PubSub.subscribe(GrassFarmer.PubSub, "time_keeper")

    new_socket =
      assign(socket,
        Loader.translate() |> Map.merge(%{time: NaiveDateTime.local_now()})
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
          <Schedule.list schedules={@schedules}/>
          <.live_component module={Zones} id="zones" zones={@zones} />
        </div>
        <div>
          <.live_component module={Footer}  id="footer" zones={@zones} />
        </div>
      </div>
    </.body>
    """
  end


  @impl true
  def handle_info({:update_time, time}, socket) do
    time_formatted = StyleBlocks.time_format(time, :just_time)
    {:noreply, assign(socket, %{time: time_formatted})}
  end

end
