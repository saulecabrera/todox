defmodule TodoxApi.Router do
  use TodoxApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TodoxApi, as: :todox_api do
    pipe_through :api
    scope "/v1", as: :v1, alias: V1 do
      resources "/todos", TodoController, except: [:new, :edit]
    end
  end
end
