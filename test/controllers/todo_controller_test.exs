defmodule Todox.TodoControllerTest do
  use Todox.ConnCase

  alias Todox.{Repo, User, Todo, Auth}

  @user %User{username: "johndoe", password: "strongpassword"}
  @valid_attrs %{description: "some content", title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, user} = Repo.insert(@user) 

    # calls api_sign_in which generates a token and puts it
    # in the connection as a request header of the form:
    #   authorization, Bearer <jwt>
    # Using this connection will result in automatic authentication
    {:ok, conn, jwt, claims, _} = Auth.generate_jwt(conn, user)
    conn = put_req_header(conn, "accept", "application/json")
    {:ok, conn: conn, jwt: jwt, user: user, claims: claims}
  end

  test "POST /todos creates a todo when request contains a valid jwt", 
  %{conn: conn, jwt: jwt, user: user} do
    conn = post conn, todo_path(conn, :create), todo: @valid_attrs 
    
    body = json_response(conn, 201)
    assert body["data"]
    assert body["data"]["title"] == @valid_attrs[:title]
    assert body["data"]["description"] == @valid_attrs[:description]
    assert body["data"]["completed"] == false
    assert body["data"]["owner"] == user.id 
  end

  test "POST /todos without providing a jwt results in 401 HTTP status" do
    conn = build_conn()
    conn = post conn, todo_path(conn, :create), todo: @valid_attrs
    assert conn.status == 401
  end

  test "POST /todos without a title results in errors", %{conn: conn} do
    conn = post conn, todo_path(conn, :create), todo: %{title: " "}

    body = json_response(conn, 422)
    assert body["errors"]["title"] == ["can't be blank"]
  end

  test "GET /todos returns all todos that belong to the current user",
  %{conn: conn, user: user} do
    post conn, todo_path(conn, :create), todo: @valid_attrs
    post conn, todo_path(conn, :create), todo: @valid_attrs
      
    conn = get conn, todo_path(conn, :index)
    body = json_response(conn, 200)
    assert length(body["data"]) == 2
    assert hd(body["data"])["owner"] == user.id
    assert List.last(body["data"])["owner"] == user.id
  end
end
