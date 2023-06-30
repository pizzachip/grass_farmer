This is based loosely on the Nerves + LiveView Example
===

(Suburban) Grass Farmer is a Nerves Project with a Pheonix/LiveView server embedded in the same application.  In contrast to
a [poncho project](https://embedded-elixir.com/post/2017-05-19-poncho-projects/), there is only one application
supervision tree containing the Phoenix Endpoint and any processes running on the device.

Currently the versions included are:

* `nerves`  - 1.9.3
* `phoenix`  - 1.7.2
* `phoenix_liveview` - 0.18.18
* `tailwindcss` - 0.2.0

Urban Grass Farmer is a hobby application sprinkler control system written in Elixir Nerves. The basic stack is:

*  Elixir/Nerves is our core language/system
*  Circuits GPIO - connect to the controller board (Hardware)
*  LiveView - this will power the front end presentation
*  Nerves Time Zones - required to manage the schedule in your local time zone
*  VintageNet - so that you can connect to your wifi and internet connection for configuring on a browser and getting weather updates
*  TBD - provides permance of configurations, schedules, and state in case of power outage (either db or just write to file - haven't decided, yet)

## UI / vision
I started this project because the only nerves-based sprinkler controller I could find was pretty old and the interface and general concept didn't match what I was looking for. I'm currently using Open Sprinkler (python-based) but the interface is pretty clunky. It seemed like this was low-hanging fruit.

You can find the vision/design and my messy notes on this [Figma page](https://www.figma.com/file/BRZ4jzr4uUPRPr4XlogAJQ/Grass-Farm?type=design&node-id=0%3A1&mode=design&t=sFJBgkOhKvA8rDyo-1).

## Contributions
If you are a fellow nerves enthusiast and would like to contribute to this project, please do. I'm not super-experience in managing open repositories like this but I'm sure you can clone and submit a pull request. If you need help, just message me and I'll try to figure it out.

## Hardware
I'm developing this on a Mango Pi MQ Pro but you should be able to deploy to any nerves target if you keep an eye on your configs. Raspberry Pi and Mango Pi have different pinouts, but that shouldn't be a problem.

In addition to the Mango or Raspberry Pi you will need a Relay Module with enough channels for the number of zones you have (6 is pretty common, I have 5). I use something like [this](https://www.amazon.com/ANMBEST-Optocoupler-Trigger-Arduino-Channel/dp/B08RRTHTYQ/ref=asc_df_B08RRTHTYQ).

If you already have a dumb (or smart) controller, you'll just replace what you have. When you implement the board, remember to chain together the ground lines on the board and connect them all to the ground from your valve controller.


Configuration
---

The order of configuration is loaded in a specific order:

* `config.exs`
* `host.exs` or `target.exs`  based on `MIX_TARGET`
* `prod.exs`, `dev.exs`, or `test.exs` based on `MIX_ENV`
* `runtime.exs` at runtime

To make configuration slightly more straightforward, the application is run 
with `MIX_ENV=prod` when on the device.  Therefore, the configuration for
phoenix on the target device is in the `prod.exs` config file.


Developing
---

You can start the application just like any Phoenix project:

```bash
iex -S mix phx.server
```


Flashing to a Device
---

You can burn the first image with the following commands:

```bash
# NOTE - I've changed the default target on the Nerves examples hello live view to the mango pi.
# If you want to enable wifi:
# export NERVES_SSID="NetworkName" && export NERVES_PSK="password"
MIX_ENV=prod MIX_TARGET=host mix do deps.get, assets.deploy
MIX_ENV=prod MIX_TARGET=mangopi_mq_pro mix do deps.get, firmware, burn
```

Once the image is running on the device, the following will build and update the firmware
over ssh.

```bash
# If you want to enable wifi:
# export NERVES_SSID="NetworkName" && export NERVES_PSK="password"
MIX_ENV=prod MIX_TARGET=host mix do deps.get, assets.deploy
MIX_ENV=prod MIX_TARGET=mangopi_mq_pro mix do deps.get, firmware, upload grass_farmer.local
```


Network Configuration
---

The network and WiFi configuration are specified in the `target.exs` file.  In order to
specify the network name and password, they must be set as environment variables `NERVES_SSID`
`NERVES_PSK` at runtime.

If they are not specified, a warning will be printed when building firmware, which either
gives you a chance to stop the build and add the environment variables or a clue as to 
why you are no longer able to access the device over WiFi.

## Special thanks
Special thanks to Frank Hunleth, the beating heart of the Nerves Project, Alex McLain, host of the [Nerves Meetup](https://www.meetup.com/nerves/members/185556624/profile/), Bruce Tate from [Grox](https://www.grox.io) whose videos inspired me to get involved in Nerves in the first place, and, of course, Jose Valim, who brought us all Elixir! 

