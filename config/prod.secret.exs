use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :todox_api, TodoxApi.Endpoint,
  secret_key_base: "pPrDD942OolyZwym5qgkseVfmRYuaoOfo74hqRjEkcyX/00C1p29sWoZH/yZkvL8"

# Configure your database
config :todox_api, TodoxApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "todox_api_prod",
  pool_size: 20
