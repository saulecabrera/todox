defmodule Todox.UserView do
  use Todox.Web, :view

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Todox.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username}
  end
end
