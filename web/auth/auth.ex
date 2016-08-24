defmodule Todox.Auth do

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias Todox.Repo
  alias Todox.User

  def generate_jwt(conn, user) do
    new_conn = Guardian.Plug.api_sign_in(conn, user)
    jwt = Guardian.Plug.current_token(new_conn)
    {:ok, claims} = Guardian.Plug.claims(new_conn)
    exp = Map.get(claims, "exp")

    {:ok, new_conn, jwt, claims, exp}
  end

  def login_by_username(username, given_pw) do
    user = Repo.get_by(User, username: username)
    cond do
      user && checkpw(given_pw, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        {:error, :not_found}
    end
  end
end
