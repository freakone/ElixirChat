defmodule ElixirChat.PageController do
  use ElixirChat.Web, :controller

  def index(conn, _params) do
    if ElixirChat.AuthController.logged_in?(conn) do
      render conn, "index.html"
    else
      render conn, "login.html"
    end
  end
end
