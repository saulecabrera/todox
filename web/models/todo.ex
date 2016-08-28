defmodule Todox.Todo do
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
    |> cast(params, [:title, :description, :completed])
    |> validate_required([:title, :description, :completed])
  end
end