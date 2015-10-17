defmodule ElixirChat.PageController do
  use ElixirChat.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
