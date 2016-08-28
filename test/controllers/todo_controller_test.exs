defmodule Todox.TodoControllerTest do
  use Todox.ConnCase

  alias Todox.Todo
  @valid_attrs %{completed: true, description: "some content", title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "POST /todos creates a todo for a authenticated user", %{conn: conn} do
    true
  end
end
