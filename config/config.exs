# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :code_name,
  ecto_repos: [CodeName.Repo]

# Configures the endpoint
config :code_name, CodeNameWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "A5+m0DpPUK5Lqi/nrE4wm7KkajeSovaa7O+RHPvdpwO8wBVcid/vkHuxpuWfbmFL",
  render_errors: [view: CodeNameWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: CodeName.PubSub,
  live_view: [signing_salt: "y/komwgk"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
