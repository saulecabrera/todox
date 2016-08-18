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

  test "shows a given user when selected by an id", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] == %{
      "id" => user.id,
      "username" => user.username
    }
  end
end
