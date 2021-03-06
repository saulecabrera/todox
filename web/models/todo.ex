defmodule Todox.Todo do
  @moduledoc """

  Module that represents a Todo model

  """
  use Todox.Web, :model

  schema "todos" do
    field :title, :string
    field :description, :string
    field :completed, :boolean, default: false
    belongs_to :user, Todox.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description])
    |> validate_required([:title])
    |> validate_length(:title, min: 1)
  end

  def update_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, [:completed])
    |> validate_inclusion(:completed, [true, false])
  end
end
