use Mix.Config

# Configure your database
db_local = System.get_env("DB_LOCATION") || "localhost"
IO.inspect(db_local)
config :api_banking, ApiBanking.Repo,
  username: "andre_paes",
  password: "postgres",
  database: "api_banking_test",
  hostname: db_local,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api_banking, ApiBankingWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
