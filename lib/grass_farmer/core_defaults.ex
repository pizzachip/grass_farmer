defmodule GrassFarmer.CoreDefaults do
  alias GrassFarmer.{ Zone, Schedule }

  def values() do
    %{
      "global" =>
        %{time_zone: "America/Chicago",
          location: "41.8781,-87.6298",
          weatherapi_key: ""
          },
      "zones" => [%Zone{name: "Front Yard", sprinkler_zone: 1}],
      "schedules" => [%Schedule{name: "Default Schedule"}],
      "watering_logs" => [],
      "rain" =>
        %{ today: 0,
           last_rain: nil,
           next_rain: nil}
    }
  end

end
