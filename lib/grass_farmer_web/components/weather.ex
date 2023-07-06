defmodule GrassFarmerWeb.Components.Weather do
  use Phoenix.Component

  import GrassFarmerWeb.Components.StyleBlocks

  def quickview(assigns) do
    ~H"""
    <div class="my-2 mx-1">
      <.tile_row_wrapper>
        <.info_tile>
          <.weather_icon />
          <.tile_text copy={%{title: "Currently", text: "Sunny"}} />
        </.info_tile>
        <.info_tile>
          <.tile_text copy={%{title: "Next Rain", text: "1 Aug"}} />
        </.info_tile>
      </.tile_row_wrapper>
    </div>
    """
  end
end
