defmodule GrassFarmerWeb.Components.Schedule do
  use Phoenix.Component

  import GrassFarmerWeb.Components.StyleBlocks

  def quickview(assigns) do
    ~H"""
    <.tile_row_wrapper>
      <.info_tile>
        <.last_icon />
        <.tile_text copy={%{title: "Last", text: "Thu 24 Jul 202X" }}/>
      </.info_tile>
      <.info_tile>
        <.next_icon />
        <.tile_text copy={%{title: "Next", text: "Sat 26 Jul 202X" }}/>
      </.info_tile>
    </.tile_row_wrapper>
    """
  end

end
