# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :sokrat, Sokrat.Robot,
  adapter: Hedwig.Adapters.Slack,
  name: System.get_env("SLACK_BOT_NAME") || "sokratbot",
  aka: "/",
  token: System.get_env("SLACK_BOT_TOKEN"),
  responders: [
    {Hedwig.Responders.Help, []},
    {Hedwig.Responders.Ping, []},
    {Sokrat.Responders.RC, []}
  ]

config :sokrat, ecto_repos: [Sokrat.Repo]
config :sokrat, Sokrat.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"}

config :sokrat,
  slack: %{channel: System.get_env("SLACK_BOT_CHANNEL"),
           token: System.get_env("SLACK_BOT_TOKEN")}

config :plug,
  port: String.to_integer(System.get_env("PORT") || "8000")

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :sokrat, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:sokrat, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
