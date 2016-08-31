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
  %{conn: conn, user: user} do
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
    other_user = insert(:user, username: "otheruser") 
    insert(:todo, user_id: other_user.id)
    insert(:todo, user_id: user.id)
    insert(:todo, user_id: user.id)

    conn = get conn, todo_path(conn, :index)
    body = json_response(conn, 200)
    assert length(body["data"]) == 2
    assert hd(body["data"])["owner"] == user.id
    assert List.last(body["data"])["owner"] == user.id
  end

  test "GET /todos returns empty array if user has not created any todos",
  %{conn: conn} do
    conn = get conn, todo_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "GET /todos without providing a jwt results in 401 HTTP status" do
    conn = build_conn()
    conn = get conn, todo_path(conn, :index)
    assert conn.status == 401
  end

  test "UPDATE /todos/:id updates attributes of a given todo via id",
  %{conn: conn, user: user} do
    todo = insert(:todo, user_id: user.id) 
    todo_params = %{completed: true, description: "New description"}
    conn = put conn, todo_path(conn, :update, todo), todo: todo_params 

    body = json_response(conn, 200)
    assert body["data"]
    assert body["data"]["completed"] == true
    assert body["data"]["description"] == todo_params[:description]
    assert body["data"]["owner"] == user.id
  end

  test "UPDATE /todos/:id results in 422 HTTP status when updating a todo from another user",
  %{conn: conn} do
    user = insert(:user, username: "foobar")
    todo = insert(:todo, user_id: user.id)
    todo_params = %{completed: true}
     
    conn = put conn, todo_path(conn, :update, todo), todo: todo_params 
    assert conn.status == 404
  end
 
  test "UPDATE /todos/:id brings errors back when wrong parameters are given",
  %{conn: conn, user: user} do
    todo = insert(:todo, user_id: user.id)
    todo_params = %{completed: 1, title: ""}
    conn = put conn, todo_path(conn, :update, todo), todo: todo_params

    body = json_response(conn, 422)
    assert body["errors"]
    assert body["errors"]["title"] == ["can't be blank"]
    assert body["errors"]["completed"] == ["is invalid"]
  end

  test "UPDATE /todos/:id without a jwt results in 401 HTTP status" do   
    user = insert(:user, username: "foobar")
    todo = insert(:todo, user_id: user.id)
    
    conn = build_conn()
    conn = put conn, todo_path(conn, :update, todo), todo: %{}

    assert conn.status == 401
  end

  test "GET /todos/:id shows chosen todo", %{user: user, conn: conn} do
    todo = insert(:todo, user_id: user.id) 
    conn = get conn, todo_path(conn, :show, todo)

    todo = json_response(conn, 200)["data"]
    assert todo["owner"] == user.id
  end

  test "GET /todos/:id when todo does not belong to current user results in 404 HTTP status",
  %{conn: conn} do
    user = insert(:user, username: "owner")
    todo = insert(:todo, user_id: user.id)
    conn = get conn, todo_path(conn, :show, todo)

    assert conn.status == 404
  end

  test "GET /todos/:id with an unexisting id results in 404 HTTP status",
  %{conn: conn} do
    conn = get conn, todo_path(conn, :show, -1)
    assert conn.status == 404
  end
  
  test "DELETE /todos/:id sucessfully deletes a todo owned by a user", 
  %{conn: conn, user: user} do
    todo = insert(:todo, user_id: user.id) 
    conn = delete conn, todo_path(conn, :delete, todo)
    
    assert response(conn, 204)
    refute Repo.get(Todo, todo.id)
  end

  test "DELETE /todos/:id results in 404 HTTP status when todo does not belong to current user",
  %{conn: conn} do
    user = insert(:user, username: "foobar")
    todo = insert(:todo, user_id: user.id)

    conn = delete conn, todo_path(conn, :delete, todo)
    assert conn.status == 404
  end

  test "DELETE /todos/:id results in 404 HTTP status when todo does not exist",
  %{conn: conn} do
    conn = delete conn, todo_path(conn, :delete, -1)
    assert conn.status == 404
  end
end
