defmodule ElixirChat.ChatChannel do
  use Phoenix.Channel
 	alias ElixirChat.AuthController
  alias ElixirChat.User
  alias ElixirChat.Message
  alias ElixirChat.Repo
  import Ecto.Query
  import Logger

  def update_status(state, socket) do
    user = Repo.get!(User, socket.assigns[:user_id])
    user = %{user | online: (user.online || 0) + (if state, do: 1, else: -1)}
    Repo.update user
  end

  def join("chat", _message, socket) do  	
    update_status(true, socket)
  	send(self, :send_users)
    send(self, :send_messages)
    {:ok, socket}
  end

   def handle_info(:send_users, socket) do
    users = User
      |> select([u], %{name: u.name, image: u.image, online: u.online})
      |> order_by([u], asc: u.name)
      |> Repo.all    

    broadcast! socket, "users", %{users: users}
    {:noreply, socket}
  end

  def handle_info(:send_messages, socket) do
    messages = Message
    |> join(:inner, [m], u in User, u.id == m.user_id) 
    |> select([m, u], %{content: m.content, user_name: u.name, user_id: u.id, id: m.id, date: m.inserted_at, user_image: u.image})
    |> limit([m], 100)
    |> Repo.all

		push socket, "messages", %{messages: messages}
		{:noreply, socket}
  end

  def terminate(reason, socket) do
    update_status(false, socket)
    handle_info(:send_users, socket)
    :ok
  end

  def handle_in("msg", msg, socket) do
    user = User
      |> select([u], %{name: u.name, image: u.image, id: u.id})
      |> Repo.get socket.assigns[:user_id]

    if user do
      message = Message.changeset(%Message{}, %{content: msg["content"], user_id: socket.assigns[:user_id]})
      
      if message.valid? do
        case Repo.insert(message) do
          {:ok, model}  ->
            map =  %{content: model.content, user_name: user.name, user_id: user.id, id: model.id, date: model.inserted_at, user_image: user.image}
            broadcast! socket, "msg", map
            {:noreply, socket}        
          {:error, changeset} ->
            {:reply, {:error, %{reason: changeset.errors}}, socket}
        end

      else
        {:reply, {:error, %{reason: "message schema not valid"}}, socket}
      end
    else
      {:reply, {:error, %{reason: "wrong user_id"}}, socket}
    end

  end

end