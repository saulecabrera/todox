ExUnit.start

Mix.Task.run "ecto.create", ~w(-r TodoxApi.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r TodoxApi.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(TodoxApi.Repo)

