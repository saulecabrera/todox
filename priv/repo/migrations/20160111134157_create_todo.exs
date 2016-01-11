defmodule TodoxApi.Repo.Migrations.CreateTodo do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :title, :string
      add :description, :string
      add :completed, :boolean, default: false

      timestamps
    end

  end
end
