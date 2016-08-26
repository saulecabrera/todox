defmodule Todox.SessionControllerTest do
  alias Todox.Repo
  alias Todox.User

  use Todox.ConnCase

  @invalid_login %{username: "nonexistent", password: "wrong_password"}
  @existing_user_wrong_pw %{username: "username", password: "wrong_password"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "login: status 401 and returned when non existing user is provided",
  %{conn: conn} do
    conn = post conn, login_path(conn, :create), credentials: @invalid_login
    assert 404 == conn.status
  end

  test "login: status 401 when existing user and bad password provided", 
  %{conn: conn} do
    user_params = %{username: "username", password: "secretpassword"}
    changeset = User.registration_changeset(%User{}, user_params)
    {:ok, user} = Repo.insert(changeset)

    conn = post conn, login_path(conn, :create), credentials: @existing_user_wrong_pw
    assert 401 == conn.status
  end
end
