defmodule Todox.SessionControllerTest do
  alias Todox.Repo
  alias Todox.User

  use Todox.ConnCase

  @invalid_login %{username: "nonexistent", password: "wrong_password"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "login: status 401 and returned when non existing user is provided",
  %{conn: conn} do
    conn = post conn, login_path(conn, :create), credentials: @invalid_login
    assert response(conn, 404) == ""
  end

  test "login: status 401 when existing user and bad password provided", 
  %{conn: conn} do
    user_params = %{username: "username", password: "secretpassword"}
    changeset = User.registration_changeset(%User{}, user_params)
    {:ok, _} = Repo.insert(changeset)

    existing_user_wrong_pw =  %{username: "username", password: "wrong_password"}
    conn = post conn, login_path(conn, :create), credentials: existing_user_wrong_pw
    assert response(conn, 401) == ""
  end

  test "login: status 200 and token response when valid credentials supplied", 
  %{conn: conn} do
    user_params = %{username: "username", password: "secretpassword"}
    changeset = User.registration_changeset(%User{}, user_params)
    {:ok, _} = Repo.insert(changeset)

    existing_user_correct_pw = %{username: "username", password: "secretpassword"}
    conn = post conn, login_path(conn, :create), credentials: existing_user_correct_pw
    body = json_response(conn, 200)

    assert body["data"]
    assert body["data"]["jwt"]
    assert body["data"]["exp"]
    assert get_resp_header(conn, "authorization")
    assert get_resp_header(conn, "x-expires")
  end
end
