defmodule GrassFarmerWeb.Components.ScheduleManager do
  use Phoenix.LiveComponent

  alias GrassFarmer.PersistenceAdapter
  alias GrassFarmer.Zones.Zone
  alias GrassFarmer.Schedules.{Schedule, ScheduleZone}
  import GrassFarmerWeb.Components.StyleBlocks
  import GrassFarmerWeb.CoreComponents

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="mb-1 mx-3">
        <div class="flex">
          <h2 class="text-xl font-bold text-gray-600">Schedules</h2>
          <button class="text-xl font-bold ml-3" phx-click="manage_schedules" phx-value-action="create" > + </button>
        </div>
        <div class="flex items-start">
          <%= for schedule <- @schedules do %>
            <div class="cursor-default py-1 px-2 mr-2 rounded-md bg-green-100 hover:bg-yellow-100" phx-click="manage_schedules" phx-value-action="edit_schedule" phx-value-id={schedule.id} ><%= schedule.name %></div>
            <%= if @edit_schedule == schedule.id  do %>
              <.schedule_modal_form myself={@myself} schedule={schedule} zones={@zones}/>
            <% end %>
            <%= if @delete_schedule == schedule.id do %>
              <.confirm_delete_modal myself={@myself} schedule={schedule} />
            <% end %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  attr :myself, :map, required: true
  attr :schedule, Schedule, required: true
  def confirm_delete_modal(assigns) do
    ~H"""
    <.modal_wrapper myself={@myself} entity={@schedule} form_title="Confirm Delete" allow_delete="no">
      <div class="py-5">
        <div class="pb-5">
          <span class="text-xl">Are you sure you want to delete <%= @schedule.name %>?</span>
        </div>
        <div class="flex justify-between">
          <span class="text-xl ml-3 text-blue-600 cursor-pointer" phx-click="manage_schedules" phx-value-id={@schedule.id} phx-value-action="delete"> Yes </span>
          <.button class="text-xl font-bold ml-3 bg-green-600 hover:bg-green-800" phx-click="manage_schedules" phx-value-action="cancel_edit" > No </.button>
        </div>
      </div>
    </.modal_wrapper>
    """
  end

  attr :myself, :map, required: true
  attr :schedule, Schedule, required: true
  attr :zones, :list, required: true
  def schedule_modal_form(assigns) do
    ~H"""
    <.modal_wrapper
      myself={@myself}
      entity={@schedule}
      form_title="Update Schedule"
      allow_delete="yes" >
      <form action="#" phx-submit="submit_schedule" phx-change="temp_update" >
        <.modal_form myself={@myself}>
          <div class="py-5">
            <div class="pb-5">
              <input type="hidden" name="id" value={@schedule.id} />
              <label class="pr-5">Name</label><input type="text" name="name" value={@schedule.name} />
            </div>
            
            <div class="pb-5 justify-between flex">
              <%= for day <- 1..7 do %>
                <div class="inline-block">
                  <button type="button" 
                    class={day_select(@schedule.days, day) <> " py-0.5 px-2"} 
                    phx-click="manage_schedules" 
                    phx-value-action="toggle_day" 
                    phx-value-day={day} 
                    phx-value-schedule={@schedule.id}
                  >
                    <%= day_string(day) %>
                  </button>
                </div>
              <% end %>
            </div>

            <label class="pr-5">Start Time</label>

            <select name="start_hour" >
              <%= for hour <- 1..12 do %>
                <%= if hour_match(hour, @schedule.start_time.hour) do %>
                  <option value={hour} selected><%= hour %></option>
                <% else %>
                  <option value={hour} ><%= hour %></option>
                <% end %>
              <% end %>
            </select>

            <span class="text-2xl font-bold">:</span>

            <select name="start_minute">
              <%= for minute <- 0..11 do %>
                <%= if minute * 5 == @schedule.start_time.minute do %>
                  <option value={minute * 5} selected label={two_digit(minute * 5)} />
                <% else %>
                  <option value={minute * 5} label={two_digit(minute * 5)} />
                <% end %>
              <% end %>
            </select>
            <span class="text-2xl font-bold">:</span>

            <select name="start_am_pm">
              <%= if @schedule.start_time.hour > 12 do %>
                <option value="AM" >AM</option>
                <option value="PM" selected >PM</option>
              <% else %>
                <option value="AM" selected >AM</option>
                <option value="PM" >PM</option>
              <% end %>
            </select>
          </div>
          <ul>
            <li class="flex justify-between p-3">
              <div>Zone Name</div>
              <div>Duration</div>
              <div>Valve Number</div>
            </li>
            <%= for zone <- @zones do %>
              <li class={zone_in_schedule_format(zone, @schedule.zones) <> " flex justify-between p-3 my-2"} 
                  phx-click="manage_schedules" 
                  phx-value-action="toggle_zone" 
                  phx-value-zone={zone.id} 
                  phx-value-schedule={@schedule.id} >
                <div><%= zone.name %></div>
                <div><%= duration(zone, @schedule.zones) %></div>
                <div><%= zone.sprinkler_zone %></div>
              </li>
            <% end %>
          </ul>
        </.modal_form>
      </form>
    </.modal_wrapper>
    """
  end

  slot :inner_block, required: true
  attr :myself, :map, required: true
  attr :entity, :map, required: true
  attr :form_title, :string, required: true
  attr :allow_delete, :string, required: true
  def modal_wrapper(assigns) do
    ~H"""
    <div class="flex justify-center h-screen w-screen top-0 left-0 fixed items-center bg-green-200/75 antialiased" phx-click="manage_schedules" phx-value-action="cancel_edit">
      <div class="flex flex-col w-11/12 sm:w-5/6 lg:w-1/2 max-w-2xl mx-auto rounded-lg border border-gray-300 shadow-xl" phx-click="" >
        <div class="flex flex-row justify-between p-6 bg-white border-b border-gray-200 rounded-tl-lg rounded-tr-lg">
          <div>
            <span class="font-semibold text-gray-800 pr-5"><%= @form_title %></span>
            <%= if @allow_delete == "yes" do %>
              <span class="font-semibold text-red-400 cursor-pointer" phx-value-action="request_delete" phx-click="manage_schedules" phx-value-id={@entity.id} >delete</span>
            <% end %>
          </div>
          <div phx-click="manage_schedules" phx-value-action="cancel_edit" >
            <.close_x />
          </div>
        </div>
        <div class="flex flex-col px-6 bg-gray-50">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  @spec duration(Zone.t(), [ScheduleZone.t()]) :: integer() 
  defp duration(zone, schedule_zones) do
    case schedule_zones do
      [] -> 0
      [nil] -> 0
      zones ->
        zones_found = Enum.find(zones, fn z -> z.zone_id == zone.id end)
        if zones_found == nil do
          0
        else
          Map.get(zones_found, :duration, 10)
        end
    end
  end

  @spec day_select([integer()], integer()) :: String.t()
  defp day_select(days, day) do
    if Enum.member?(days, day), do: "bg-green-400 text-white", else: "bg-gray-200 text-gray-600"
  end

  @spec zone_in_schedule_format(Zone.t(), [ScheduleZone.t()]) :: String.t()
  defp zone_in_schedule_format(zone, schedule_zones) do
    zone_ids = 
      schedule_zones
      |> Enum.map(&(&1.zone_id)) 
    if Enum.member?(zone_ids, zone.id), do: "bg-green-200", else: "bg-yellow-200"
  end

end
