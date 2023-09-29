defmodule GrassFarmer.CoreDefaults do
  alias GrassFarmer.Schedules.Schedule
  alias GrassFarmer.Zones.Zone

  def values() do
    %{
      "global" =>
        %{time_zone: "America/Chicago",
          location: "41.8781,-87.6298",
          weatherapi_key: ""
          },
      "zones" => [%Zone{id: Ecto.UUID.generate(), name: "Front Yard", sprinkler_zone: 1}],
      "schedules" => [%Schedule{id: Ecto.UUID.generate(), 
        name: "Default Schedule",
        start_time: ~T[07:00:00],
        days: 1..7,
        zones: []}],
      "watering_logs" => [],
      "rain" =>
        %{ today: 0,
           last_rain: nil,
           next_rain: nil}
    }
  end

end
