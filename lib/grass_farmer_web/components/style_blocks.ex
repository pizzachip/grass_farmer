defmodule GrassFarmerWeb.Components.StyleBlocks do
  use Phoenix.Component

  slot :inner_block, required: true
  def tile_row_wrapper(assigns) do
    ~H"""
    <div class="flex items-start text-gray-800">
      <div class="w-full">
        <div class="grid grid-cols-2 gap-1">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  slot :inner_block, required: true
  def info_tile(assigns) do
    ~H"""
      <div class="col-span-1 shadow">
        <div class="flex flex-row bg-white shadow-sm rounded p-2">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    """
  end

  attr :copy, :map, required: true
  def tile_text(assigns) do
    ~H"""
    <div class="flex flex-col flex-grow ml-4">
      <div class="text-sm text-gray-500"><%= @copy.title %></div>
      <div class="font-bold text-md"><%= @copy.text %></div>
    </div>
    """
  end

  def last_icon(assigns) do
    ~H"""
    <div class="flex items-center justify-center flex-shrink-0 h-8 w-8 md:h-12 sm:w-12 rounded-xl bg-blue-100 text-blue-500">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
        <path stroke-linecap="round" stroke-linejoin="round" d="M9 15L3 9m0 0l6-6M3 9h12a6 6 0 010 12h-3" />
      </svg>
    </div>
    """
  end

  def next_icon(assigns) do
    ~H"""
      <div class="flex items-center justify-center flex-shrink-0 h-8 w-8 md:h-12 sm:w-12 rounded-xl bg-green-100 text-green-500">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="M15 15l6-6m0 0l-6-6m6 6H9a6 6 0 000 12h3" />
        </svg>
      </div>
    """
  end

  def weather_icon(assigns) do
    # For now, just return sunny icon
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
      <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v2.25m6.364.386l-1.591 1.591M21 12h-2.25m-.386 6.364l-1.591-1.591M12 18.75V21m-4.773-4.227l-1.591 1.591M5.25 12H3m4.227-4.773L5.636 5.636M15.75 12a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0z" />
    </svg>
    """
  end

  def edit_pencil(assigns) do
    ~H"""
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
        <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L6.832 19.82a4.5 4.5 0 01-1.897 1.13l-2.685.8.8-2.685a4.5 4.5 0 011.13-1.897L16.863 4.487zm0 0L19.5 7.125" />
      </svg>
    """
  end

  slot :inner_block, required: true
  attr :status, :string, required: true
  def button_inset(assigns) do
    ~H"""
    <div class={inset_color(@status) <> "flex flex-col flex-grow ml-4"}>
      <div class="font-bold text-md">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp inset_color(status) do
    case status do
      "on" -> "bg-white"
      _    -> "bg-yellow-500"
    end
  end
end
