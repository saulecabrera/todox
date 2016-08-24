defmodule Todox.SessionControllerTest do
  alias Todox.Repo
  alias Todox.User

  use Todox.ConnCase

  @invalid_login %{username: "nonexistent", password: "wrong_password"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "login: error 401 and errors are returned when bad credentials or non existing user is provided",
  %{conn: conn} do
    conn = post conn, login_path(conn, :create), credentials: @invalid_login
    body = json_response(conn, 404)
  end
end
