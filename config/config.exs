# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

################################################################
## Phoenix Config
################################################################

# Configures the endpoint
config :grass_farmer, GrassFarmerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: GrassFarmerWeb.ErrorHTML, json: GrassFarmerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: GrassFarmer.PubSub,
  live_view: [signing_salt: "1g+qVw8s"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

################################################################
## Nerves Config
################################################################

Application.start(:nerves_bootstrap)

config :grass_farmer, target: Mix.target()

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1672328776"

if Mix.target() == :host do
  import_config "host.exs"
else
  import_config "target.exs"
end

################################################################
## Common Config
################################################################

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# For local time on the device
config :nerves_time_zones, data_dir: "./tmp/nerves_time_zones"
config :nerves_time_zones, default_time_zone: "America/Chicago"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
config :grass_farmer,
  :set_names,
  [
    "global",
    "zones",
    "schedules",
    "watering_logs",
    "rain"
  ]

import_config "#{config_env()}.exs"
