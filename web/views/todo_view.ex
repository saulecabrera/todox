defmodule Todox.TodoView do
  use Todox.Web, :view

  def render("index.json", %{todos: todos}) do
    %{data: render_many(todos, Todox.TodoView, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, Todox.TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{id: todo.id,
      owner: todo.user_id,
      title: todo.title,
      description: todo.description,
      completed: todo.completed}
  end
end
