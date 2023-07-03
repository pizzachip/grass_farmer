defmodule GrassFarmerWeb.Home do
  use GrassFarmerWeb, :live_view
  alias GrassFarmerWeb.Components.{Schedule, Weather}
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
      </.body>
    """
  end
end
