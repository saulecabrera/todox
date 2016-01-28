defmodule TodoxApi.User do
  use TodoxApi.Web, :model

  schema "users" do
    field :username, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    timestamps
  end

  @required_fields ~w(username encrypted_password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_confirmation(:password, message: "Password and password confirmation do not match")
    |> validate_format(:username, ~r/\A[a-zA-Z0-9_]+\z/)
    |> validate_length(:username, min: 4)
    |> unique_constraint(:username)
  end
end
