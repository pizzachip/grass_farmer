defmodule GrassFarmerWeb.Home do
  use GrassFarmerWeb, :live_view
  alias GrassFarmerWeb.Components.{Schedule, Weather, Zones, Footer}
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
      <.page_title title="Suburban Grass Farmer" />
      <.body>
        <Schedule.quickview />
        <Weather.quickview />
        <Zones.list />
        <Footer.controls watering_status="off" time_left="5" />
      </.body>
    """
  end
end
