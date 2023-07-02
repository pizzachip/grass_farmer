defmodule GrassFarmerWeb.Home do
  alias GrassFarmerWeb.Components.Schedule
  use GrassFarmerWeb, :live_view

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
      </.body>
    """
  end
end
