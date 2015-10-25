defmodule ElixirChat.UserTest do
  use ElixirChat.ModelCase

  alias ElixirChat.User

  @valid_attrs %{fb_id: 42, fb_img: "some content", fb_mail: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
