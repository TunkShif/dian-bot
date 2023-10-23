import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :dian, Dian.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "dian_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# Configure go-cqhttp
config :dian, Dian.QQ, base_url: "http://localhost:5700", access_token: "i780712"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dian, DianWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "74Wf8OymJl0XdvU+Kyyfp2gT91VmO8IKiBk/4MthOcHVc1sUqNHaGpgPX34QSBAo",
  server: false

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Prevent Oban from running jobs and plugins during test runs
config :dian, Oban, testing: :inline

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
