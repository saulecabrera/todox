defmodule Todox.UserView do
  use Todox.Web, :view

  def render("registration.json", %{user: user, jwt: jwt, exp: exp}) do
    %{
      data: %{
        id: user.id,
        username: user.username,
        jwt: jwt,
        exp: exp
      }
    }
  end
end
