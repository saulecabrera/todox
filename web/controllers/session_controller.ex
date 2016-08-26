defmodule Todox.SessionController do
  use Todox.Web, :controller

  alias Todox.User
  alias Todox.Auth

  def create(conn, %{"credentials" => %{"username" => username, "password" => pw}}) do
    case Auth.login_by_username(username, pw) do
      {:ok, user} ->
        {:ok, conn, jwt, claims, exp} = Auth.generate_jwt(conn, user)

        conn
        |> put_status(:ok)
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", to_string(exp))
        |> render("registration.json", user: user, jwt: jwt, exp: exp)
      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
    end
  end
end
