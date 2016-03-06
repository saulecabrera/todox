use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :todox, Todox.Endpoint,
  secret_key_base: "I6Qd9BLidYJNZpKcPlrlKlSFTB+1gG0Y+/KTaIl8DdbDNNkf2gmOXroy69M2eXRN"

# Configure your database
config :todox, Todox.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "todox_prod",
  pool_size: 20
