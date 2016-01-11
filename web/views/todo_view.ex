defmodule TodoxApi.TodoView do
  use TodoxApi.Web, :view

  def render("index.json", %{todos: todos}) do
    %{data: render_many(todos, TodoxApi.TodoView, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, TodoxApi.TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{id: todo.id,
      title: todo.title,
      description: todo.description,
      completed: todo.completed}
  end
end
