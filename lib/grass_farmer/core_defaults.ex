defmodule GrassFarmer.CoreDefaults do
  alias GrassFarmer.Zone

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
        [%{id: 1,
           name: "Default Schedule",
           days: "1357",
           start_time: "07:00",
           duration_mins: [%{zone_id: 1, duration: "10"}]
        }],
      "watering_logs" => [], # format | [%{"zone_id" => 1, "start_time" => "", "end_time" => ""}]
      "rain" =>
        %{ today: 0,
           last_rain: nil,
           next_rain: nil}
    }
  end

end
