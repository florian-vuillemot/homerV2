# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :homer,
  ecto_repos: [Homer.Repo]

# Configures the endpoint
config :homer, HomerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CFu76DFYGmiDb9wCZx8f/CWhDgraUyt80TDbiUp+4r0QbU/hyk3QGLivTZH9r7St",
  render_errors: [view: HomerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Homer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
