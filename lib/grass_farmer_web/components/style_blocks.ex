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

  slot :inner_block, required: true
  attr :myself, :map, required: true
  attr :schedule, :map, required: true
  attr :form_title, :string, required: true

  def modal_wrapper(assigns) do
    ~H"""
    <div class="flex justify-center h-screen w-screen top-0 left-0 fixed items-center bg-green-200/75 antialiased" phx-click="cancel_edit" phx-target={@myself}>
      <div class="flex flex-col w-11/12 sm:w-5/6 lg:w-1/2 max-w-2xl mx-auto rounded-lg border border-gray-300 shadow-xl" phx-click="" phx-target={@myself}>
        <div class="flex flex-row justify-between p-6 bg-white border-b border-gray-200 rounded-tl-lg rounded-tr-lg">
          <p class="font-semibold text-gray-800"><%= @form_title %></p>
          <div phx-click="cancel_edit" phx-target={@myself} >
            <.close_x />
          </div>
        </div>
        <div class="flex flex-col px-6 py-5 bg-gray-50">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  slot :inner_block, required: true
  attr :myself, :map, required: true
  def modal_form(assigns) do
    ~H"""
    <div >
      <%= render_slot(@inner_block) %>
      <div class="flex flex-row items-center justify-between py-5 border-t border-gray-200" >
        <p class="font-semibold text-blue-600 cursor-pointer" phx-click="cancel_edit" phx-target={@myself} >Cancel</p>
        <input class="px-4 py-2 text-white font-semibold bg-blue-500 rounded" phx-target={@myself} type="submit" value="Save" />
      </div>
    </div>
    """
  end

  def close_x(assigns) do
    ~H"""
    <svg class="w-6 h-6 cursor-pointer" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
    </svg>
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
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        stroke-width="1.5"
        stroke="currentColor"
        class="w-6 h-6"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          d="M9 15L3 9m0 0l6-6M3 9h12a6 6 0 010 12h-3"
        />
      </svg>
    </div>
    """
  end

  def next_icon(assigns) do
    ~H"""
    <div class="flex items-center justify-center flex-shrink-0 h-8 w-8 md:h-12 sm:w-12 rounded-xl bg-green-100 text-green-500">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        stroke-width="1.5"
        stroke="currentColor"
        class="w-6 h-6"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          d="M15 15l6-6m0 0l-6-6m6 6H9a6 6 0 000 12h3"
        />
      </svg>
    </div>
    """
  end

  def weather_icon(assigns) do
    # For now, just return sunny icon
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M12 3v2.25m6.364.386l-1.591 1.591M21 12h-2.25m-.386 6.364l-1.591-1.591M12 18.75V21m-4.773-4.227l-1.591 1.591M5.25 12H3m4.227-4.773L5.636 5.636M15.75 12a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0z"
      />
    </svg>
    """
  end

  def edit_pencil(assigns) do
    ~H"""
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        stroke-width="1.5"
        stroke="currentColor"
        class="w-5 h-5"
      >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L6.832 19.82a4.5 4.5 0 01-1.897 1.13l-2.685.8.8-2.685a4.5 4.5 0 011.13-1.897L16.863 4.487zm0 0L19.5 7.125"
      />
    </svg>
    """
  end

  def delete(assigns) do
    ~H"""
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        stroke-width="1.5"
        stroke="currentColor"
        class="w-5 h-5"
      >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0"
      />
    </svg>

    """
  end

  def input(assigns) do
    ~H"""
    <input type="text" name={@field.name} id={@field.id} value={@field.value} />
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
      _ -> "bg-yellow-500"
    end
  end

  @spec time_format(NaiveDateTime, atom()) :: String.t()
  def time_format(date, format) do
    month = date.month |> month_string
    time = date |> NaiveDateTime.to_time() |> Time.to_string() |> String.slice(0..4)
    year = date.year |> to_string
    day = date.day |> to_string

    case format do
      :just_date -> "#{month} #{day}"
      :just_time -> "#{time}"
      :full -> "#{month} #{day}, #{year} #{time}"
    end
  end

  @spec month_string(integer()) :: String.t()
  def month_string(month) do
    case month do
      1 -> "Jan"
      2 -> "Feb"
      3 -> "Mar"
      4 -> "Apr"
      5 -> "May"
      6 -> "Jun"
      7 -> "Jul"
      8 -> "Aug"
      9 -> "Sep"
      10 -> "Oct"
      11 -> "Nov"
      12 -> "Dec"
    end
  end
end
