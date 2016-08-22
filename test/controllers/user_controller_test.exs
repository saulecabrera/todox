defmodule Todox.UserControllerTest do
  alias Todox.Repo
  alias Todox.User

  use Todox.ConnCase

  @valid_attrs %{password: "some content", username: "username"}
  @invalid_attrs %{}

  @blank_errors ["can't be blank"]
  @invalid_username %{username: "john doe!"}
  @invalid_password %{password: "1234567"}

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

  test "register: custom error message on username format", %{conn: conn} do
    conn = post conn, register_path(conn, :create), user: @invalid_username
    body = json_response(conn, 422)
    assert body["errors"]
    assert body["errors"]["username"] == ["can only be composed of letters, digits and _"]
  end

  test "register: error message when password length is not 8 - 100", %{conn: conn} do
    conn = post conn, register_path(conn, :create), user: @invalid_password
    body = json_response(conn, 422)
    assert body["errors"]
    assert body["errors"]["password"] == ["should be at least 8 character(s)"]
  end

  # Test already existing resource

  test "register: process user login on registration", %{conn: conn} do
    conn = post conn, register_path(conn, :create), user: @valid_attrs
    body = json_response(conn, 201)
    assert body["data"]
    assert body["data"]["jwt"]
    assert body["data"]["exp"]
    assert get_resp_header(conn, "authorization")
    assert get_resp_header(conn, "x-expires")
  end
end
