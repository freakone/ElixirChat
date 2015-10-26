defmodule ElixirChat.Router do
  use ElixirChat.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ElixirChat do
    pipe_through :browser
    get "/current_user", ApiController, :current_user
  end

  scope "/", ElixirChat do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/auth", ElixirChat do
    pipe_through :browser
    get "/signout", AuthController, :logout
    get "/:provider", AuthController, :index
    get "/:provider/callback", AuthController, :callback
  end

end
