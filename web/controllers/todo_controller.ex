defmodule Todox.TodoController do
  use Todox.Web, :controller

  alias Todox.{Todo, Auth}
  plug Guardian.Plug.EnsureAuthenticated, handler: Auth

  def index(conn, _params, user) do
    todos = Repo.all(user_todos(user))
    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"todo" => todo_params}, user) do
    changeset = 
      user
      |> build_assoc(:todos)
      |> Todo.changeset(todo_params)

    case Repo.insert(changeset) do
      {:ok, todo} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", todo_path(conn, :show, todo))
        |> render("show.json", todo: todo)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Todox.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    todo = Repo.get!(user_todos(user), id)
    render(conn, "show.json", todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = Repo.get!(Todo, id)
    changeset = Todo.changeset(todo, todo_params)

    case Repo.update(changeset) do
      {:ok, todo} ->
        render(conn, "show.json", todo: todo)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Todox.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Repo.get!(Todo, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(todo)

    send_resp(conn, :no_content, "")
  end

  # Default action function (exists in every controller)
  # It's a plug that dispatches to the proper action at 
  # the end of the controller pipeline
  def action(conn, _) do
    current_user = Guardian.Plug.current_resource(conn)
    apply(__MODULE__, action_name(conn), 
          [conn, conn.params, current_user])
  end

  defp user_todos(user) do
    assoc(user, :todos)
  end
end
