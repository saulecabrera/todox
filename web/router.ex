defmodule Todox.Router do
  use Todox.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    # Looks for authorization token in header
    # if one is not found, nothing happens
    plug Guardian.Plug.VerifyHeader

    # Serializes the resouce and makes it available in
    # Guardian.Plug.current_resource(conn) if available;
    # if not available it returns nil
    plug Guardian.Plug.LoadResource
  end

  scope "/", Todox do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Todox do
    pipe_through :api

    post "/register", UserController, :create, as: :register
    post "/login", SessionController, :create, as: :login

    scope "/self" do
      resources "/todos", TodoController, except: [:new, :edit]
    end
  end
end
