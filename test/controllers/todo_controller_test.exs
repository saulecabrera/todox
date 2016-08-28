defmodule Todox.TodoControllerTest do
  use Todox.ConnCase

  alias Todox.{Repo, User, Todo, Auth}

  @user %User{username: "johndoe", password: "strongpassword"}
  @valid_attrs %{completed: true, description: "some content", title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, user} = Repo.insert(@user) 
    {:ok, conn, jwt, claims, _} = Auth.generate_jwt(conn, user)
    conn = put_req_header(conn, "accept", "application/json")
    {:ok, conn: conn, jwt: jwt, user: user, claims: claims}
  end

  test "POST /todos creates a todo when request contains a valid jwt", 
  %{conn: conn, jwt: jwt, user: user} do
    conn = conn |> put_req_header("authorization", "Bearer #{jwt}")  
    conn = post conn, todo_path(conn, :create), todo: @valid_attrs 
    
    body = json_response(conn, 201)
    assert body["data"]
    assert body["data"]["title"] == @valid_attrs[:title]
    assert body["data"]["description"] == @valid_attrs[:description]
    assert body["data"]["completed"] == @valid_attrs[:completed]
    assert body["data"]["owner"] == user.id 
  end
end
