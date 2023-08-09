defmodule GrassFarmer.CoreDefaults do
  alias GrassFarmer.{ Zone, Schedule }

  def values() do
    %{
      "global" =>
        %{time_zone: "America/Chicago",
          location: "41.8781,-87.6298",
          weatherapi_key: ""
          },
      "zones" => [%Zone{id: 1,
        name: "Edit to name me",
        status: "off"}],
      "schedules" =>
        [%Schedule{id: 1,
           name: "Example Schedule - not active",
           start_time: ~T[07:00:00],
           zones: [%{order: 1, zone_id: 1, duration: 10}],
           days: [1,3,5,7],
           status: :inactive
        }],
      "watering_logs" => [], # format | [%{"zone_id" => 1, "start_time" => "", "end_time" => ""}]
      "rain" =>
        %{ today: 0,
           last_rain: nil,
           next_rain: nil}
    }
  end

end
