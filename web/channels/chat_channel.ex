defmodule ElixirChat.ChatChannel do
  use Phoenix.Channel

  def join("chat", _message, socket) do
    {:ok, socket}
  end
end