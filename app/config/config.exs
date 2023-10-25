# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :dian,
  ecto_repos: [Dian.Repo]

# Configures the endpoint
config :dian, DianWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: DianWeb.ErrorHTML, json: DianWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Dian.PubSub,
  live_view: [signing_salt: "AQQeMusE"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :dian, Dian.Mailer, adapter: Swoosh.Adapters.Local

# Configure Oban
config :dian, Oban,
  queues: [default: 10],
  plugins: [Oban.Plugins.Pruner],
  repo: Dian.Repo

# Configure web push
config :dian, Dian.WebPush,
  vapid_public_key:
    "BJxEWJjvN4vAjC159Bbm77C3djrbEQ289dv-jUw8KkULtGcguDxpg17BCmQu6QA2MGBZZfup7GQ38zJtwH0sOSw",
  vapid_private_key: "Cd8V9CsHOwCGLTB8ukIKI5VQ7DQLiUx8beBTcozPSos",
  vapid_subject: "mailto:admin@email.com"

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=esnext --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ],
  service_worker: [
    args: ~w(js/sw.js --bundle --target=esnext --outdir=../priv/static/),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tesla, :adapter, {Tesla.Adapter.Finch, name: Dian.Finch}

config :nanoid,
  size: 7,
  alphabet: "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
