defmodule ElixirChat.ApiController do
  use ElixirChat.Web, :controller

  def current_user(conn, _params) do
  	user = ElixirChat.AuthController.current_user(conn)
  	map = %{token: Phoenix.Token.sign(conn, "user", user.id), user: user.id}
  	render(conn, "current_user.json", map: map)
  end
end
