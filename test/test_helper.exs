ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Todox.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Todox.Repo --quiet)
Ecto.Adapters.SQL.Sandbox.mode(Todox.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)

