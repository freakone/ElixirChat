defmodule ElixirChat.ChatChannel do
  use Phoenix.Channel
 	alias ElixirChat.AuthController

  def join("chat", _message, socket) do  	
  	send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
		push socket, "msg", %{list: "asd"}
		{:noreply, socket}
  end

end