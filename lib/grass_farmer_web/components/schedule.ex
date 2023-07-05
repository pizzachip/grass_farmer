defmodule GrassFarmerWeb.Components.Schedule do
  use Phoenix.Component

  import GrassFarmerWeb.Components.StyleBlocks

  def quickview(assigns) do
    ~H"""
    <div class="mb-1 mx-1">
      <.tile_row_wrapper>
        <.info_tile>
          <.last_icon />
          <.tile_text copy={%{title: "Last Watering", text: "Thu 24 Jul" }}/>
        </.info_tile>
        <.info_tile>
          <.next_icon />
          <.tile_text copy={%{title: "Next", text: "Sat 26 Jul" }}/>
        </.info_tile>
      </.tile_row_wrapper>
    </div>
    """
  end

end
