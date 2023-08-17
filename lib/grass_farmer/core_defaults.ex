defmodule GrassFarmer.CoreDefaults do
  alias GrassFarmer.{ Zone, Schedule }

  def values() do
    %{
      "global" =>
        %{time_zone: "America/Chicago",
          location: "41.8781,-87.6298",
          weatherapi_key: ""
          },
      "zones" => [%Zone{sprinkler_zone: 1}],
      "schedules" =>
        [%Schedule{id: 1, name: "default"}],
      "watering_logs" => [], # format | [%{"zone_id" => 1, "start_time" => "", "end_time" => ""}]
      "rain" =>
        %{ today: 0,
           last_rain: nil,
           next_rain: nil}
    }
  end

end
