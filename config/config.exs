# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pic,
  ecto_repos: [Pic.Repo]

# Configures the endpoint
config :pic, PicWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KTAqbmkYYA1BzQiWHy9vvmyo3/S9O5ECV88/ubKctKKdnHmWanHhMjwjR6DeDXy0",
  render_errors: [view: PicWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Pic.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :pic, PicWeb.Gettext, locales: ~w(en zh),
default_locale: "zh"

config :pic, Pic.Scheduler,
  jobs: [
    phoenix_job: [
      schedule: "* */24 * * *",
      task: {Pic.Task, :delete_useless_tags, []},
    ]
  ]

config :pic, Pic.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.gmail.com",
  port: 587,
  username: System.get_env("SMTP_USERNAME"),
  password: System.get_env("SMTP_PASSWORD"),
  tls: :if_available,
  ssl: false,
  retries: 1

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
