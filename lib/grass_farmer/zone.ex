defmodule GrassFarmer.Zone do
  defstruct [
    :id,
    name: "e.g. Front Yard",
    status: "off",
    edit: false,
    last_watered: ~N[1776-07-04 12:34:56],
    next_watering: NaiveDateTime.add(NaiveDateTime.local_now(), 86_400, :second),
    watering_time_left: 0
  ]
end
