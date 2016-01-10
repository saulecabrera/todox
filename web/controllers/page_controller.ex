defmodule TodoxApi.PageController do
  use TodoxApi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
