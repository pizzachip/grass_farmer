defmodule GrassFarmer.Repo do
  use Ecto.Repo,
    otp_app: :grass_farmer,
    adapter: Ecto.Adapters.SQLite3
end
