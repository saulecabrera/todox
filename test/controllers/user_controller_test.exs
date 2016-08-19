defmodule Todox.UserControllerTest do
  alias Todox.Repo
  alias Todox.User

  use Todox.ConnCase, async: true

  @valid_attrs %{password: "some content", username: "username"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "register: creates a new user", %{conn: conn} do
    conn = post conn, register_path(conn, :create), user: @valid_attrs
    body = json_response(conn, 201)
    assert body["data"]["id"]
    assert "username" == body["data"]["username"]
  end
end
