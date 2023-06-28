# GrassFarmerFirmware

# Urban Grass Farmer
Urban Grass Farmer is a hobby application sprinkler control system written in Elixir Nerves. The basic stack is:
* Elixir/Nerves is our core language/system
* Circuits GPIO - connect to the controller board (Hardware)
* LiveView - this will power the front end presentation
* Nerves Time Zones - required to manage the schedule in your local time zone
* VintageNet - so that you can connect to your wifi and internet connection for configuring on a browser and getting weather updates
* TBD - provides permance of configurations, schedules, and state in case of power outage (either db or just write to file - haven't decided, yet) 

## Hardware
I'm developing this on a Mango Pi MQ Pro but you should be able to deploy to any nerves target if you keep an eye on your configs. Raspberry Pi and Mango Pi have different pinouts, but that shouldn't be a problem.

In addition to the Mango or Raspberry Pi you will need a Relay Module with enough channels for the number of zones you have (6 is pretty common, I have 5). I use something like [this](https://www.amazon.com/ANMBEST-Optocoupler-Trigger-Arduino-Channel/dp/B08RRTHTYQ/ref=asc_df_B08RRTHTYQ).

If you already have a dumb (or smart) controller, you'll just replace what you have. When you implement the board, remember to chain together the ground lines on the board and connect them all to the ground from your valve controller.

## Deploying the firmware
cd path/to/grass_farmer_ui

### We want to build assets on our host machine.
export MIX_TARGET=host
export MIX_ENV=dev

### This needs to be repeated when you change dependencies for the UI.
mix deps.get

### This needs to be repeated when you change JS or CSS files.
mix assets.deploy

## Now we can build the firmware.
cd path/to/grass_farmer_firmware

### Specify our target device.
export MIX_TARGET=rpi3
export MIX_ENV=dev

mix deps.get
mix firmware

### (Connect the SD card)
mix firmware.burn

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

## Getting Started

To start your Nerves app:
  * `export MIX_TARGET=my_target` or prefix every command with
    `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi3`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix burn`

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: https://nerves-project.org/
  * Forum: https://elixirforum.com/c/nerves-forum
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves

## Special thanks
Special thanks to Frank Hunleth, the beating heart of the Nerves Project, Alex McLain, host of the [Nerves Meetup](https://www.meetup.com/nerves/members/185556624/profile/), Bruce Tate from [Grox](https://www.grox.io) whose videos inspired me to get involved in Nerves in the first place, and, of course, Jose Valim, who brought us all Elixir! 