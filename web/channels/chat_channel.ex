defmodule ElixirChat.ChatChannel do
  use Phoenix.Channel
 	alias ElixirChat.AuthController
  alias ElixirChat.User
  alias ElixirChat.Message
  alias ElixirChat.Repo
  import Ecto.Query

  def join("chat", _message, socket) do  	
  	send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    users = User
      |> select([u], %{name: u.name, image: u.image})
      |> Repo.all
    
    messages = Message
      |> select([m], %{content: m.content, user_id: m.user_id})
      |> Repo.all

		push socket, "init", %{users: users, messages: messages}
		{:noreply, socket}
  end

  def handle_in("msg", msg, socket) do

    user = User
      |> select([u], %{name: u.name, image: u.image})
      |> Repo.get socket.assigns[:user_id]

    if user do
      message = Message.changeset(%Message{}, %{content: msg["content"], user_id: socket.assigns[:user_id]})
      if message.valid?, do: Repo.insert(message)

      map = %{user: user, body: msg["content"]}
      broadcast! socket, "msg", map
      {:reply, {:ok, map}, socket}
    else
      {:error, socket}
    end

  end

end