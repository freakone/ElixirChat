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

  scope "/", ElixirChat do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/auth", ElixirChat do
    pipe_through :browser

    get "/:provider", AuthController, :index
    get "/:provider/callback", AuthController, :callback
    get "/logout", AuthController, :logout
  end

end
