defmodule Todox.Auth do

  def generate_jwt(conn, user) do
    new_conn = Guardian.Plug.api_sign_in(conn, user)
    jwt = Guardian.Plug.current_token(new_conn)
    {:ok, claims} = Guardian.Plug.claims(new_conn)
    exp = Map.get(claims, "exp")

    {new_conn, jwt, claims, exp}
  end
end
