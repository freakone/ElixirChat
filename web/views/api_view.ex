defmodule ElixirChat.ApiView do
  use ElixirChat.Web, :view

  def render("current_user.json", %{map: map}) do
    map
  end
end