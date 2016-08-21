defmodule Todox.UserControllerTest do
  alias Todox.Repo
  alias Todox.User

  use Todox.ConnCase

  @valid_attrs %{password: "some content", username: "username"}
  @invalid_attrs %{}

  @blank_errors ["can't be blank"]

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "register: creates a new user with valid and required attributes",
  %{conn: conn} do
    conn = post conn, register_path(conn, :create), user: @valid_attrs
    body = json_response(conn, 201)
    assert body["data"]["id"]
    assert "username" == body["data"]["username"]
    refute body["data"]["password_hash"]
    refute body["data"]["password"]

    id = body["data"]["id"]
    user = Repo.get(User, id)
    assert user.password_hash
    refute user.password
  end

  test "register: 422 HTTP error when wrong attributes provided", %{conn: conn} do
    conn = post conn, register_path(conn, :create), user: @invalid_attrs
    body = json_response(conn, 422)
    assert body["errors"]
    assert body["errors"]["username"] == @blank_errors
    assert body["errors"]["password"] == @blank_errors
  end
end
