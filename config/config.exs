# This file is responsible for configuring your application and its
# dependencies.
#
# This configuration file is loaded before any dependency and is restricted to
# this project.
import Config

# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

config :grass_farmer, target: Mix.target()

config :grass_farmer,
  ecto_repos: [GrassFarmer.Repo]

config :grass_farmer, GrassFarmerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: GrassFarmerWeb.ErrorHTML, json: GrassFarmerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: GrassFarmer.PubSub,
  live_view: [signing_salt: "CLyI0vis"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your broswer, at "/dev/mailbox".
#
# For production, it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :grass_farmer, GrassFarmer.Mailer, adapter: Swoosh.Adapters.Local

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

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
# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1687960087"

# Gives device access to local time
config :nerves_time_zones,
  data_dir: "./tmp/nerves_time_zones",
  default_time_zone: "America/Chicago"


if Mix.target() == :host do
  import_config "host.exs"
else
  import_config "target.exs"
end
