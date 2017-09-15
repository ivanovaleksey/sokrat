use Mix.Config

config :logger,
  backends: [{LoggerFileBackend, :log}]

config :logger, :log,
  path: Path.join([File.cwd!, "log", "prod.log"]),
  level: :debug
