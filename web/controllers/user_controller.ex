defmodule Todox.UserController do
  use Todox.Web, :controller

  alias Todox.User
  alias Todox.Auth

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        # refactor this out with SessionController.create/2 ?
        {:ok, conn, jwt, claims, exp} = Auth.generate_jwt(conn, user)

        conn
        |> put_status(:created)
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", to_string(exp))
        |> render("auth.json", user: user, jwt: jwt, exp: exp)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Todox.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
