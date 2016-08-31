defmodule Todox.TodoTest do
  use Todox.ModelCase

  alias Todox.Todo

  @valid_attrs %{description: "Todo description", title: "Todo title"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Todo.changeset(%Todo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Todo.changeset(%Todo{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with empty title" do
    changeset = Todo.changeset(%Todo{}, %{title: ""})
    refute changeset.valid?
  end
end
