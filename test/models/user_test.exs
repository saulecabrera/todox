defmodule Todox.UserTest do
  use Todox.ModelCase

  alias Todox.User
  alias Todox.Repo
  
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  @valid_attrs %{password: "some content", username: "user_name"}
  @invalid_attrs %{}

  test "user registration with valid username and password" do
    changeset = User.registration_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with empty attributes" do
    changeset = User.registration_changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid username on registration (containing spaces)" do
    changeset = User.registration_changeset(%User{}, %{username: "username with spaces"})
    refute changeset.valid?
  end

  test "changeset with invalid username on registration (containing special characters other than _)" do
    changeset = User.registration_changeset(%User{}, %{username: "no_spaces_other_char%?"})
    refute changeset.valid?
  end

  test "changeset with invalid password on registration (invalid length)" do
    changeset = User.registration_changeset(%User{}, %{password: "1234567"})
    refute changeset.valid?
  end

  test "fails when trying to insert duplicate usernames" do
    changeset = User.registration_changeset(%User{}, %{password: "12345678", username: "00xxFF"})
    {:ok, _} = Repo.insert(changeset)

    changeset_with_constraint = User.registration_changeset(%User{}, %{password: "some password here", username: "00xxFF"})
    refute match? {:error, ^changeset_with_constraint}, Repo.insert(changeset_with_constraint)
  end
end
