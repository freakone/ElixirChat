defmodule ElixirChat.ChatChannel do
  use Phoenix.Channel
 	alias ElixirChat.AuthController
  import Ecto.Query, only: [from: 2]

  def join("chat", _message, socket) do  	
  	send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    query = from u in ElixirChat.User, select: u.name
    msg = ElixirChat.Repo.all(query)
		push socket, "msg", %{messages: msg}
		{:noreply, socket}
  end

end