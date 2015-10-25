defmodule ElixirChat.User do
  use ElixirChat.Web, :model
  alias ElixirChat.User
  alias ElixirChat.Repo

  schema "users" do
    field :name, :string
    field :fb_id, :integer
    field :fb_img, :string
    field :fb_mail, :string

    has_many :messages, ElixirChat.Message

    timestamps
  end

  @required_fields ~w(name fb_id fb_img fb_mail)
  @optional_fields ~w()

  def add_user(user_params) do

    Repo.get_by!(User, fb_id: user_params[:fb_id])
    changeset = User.changeset(%User{}, Map.put(user_params))

    if changeset.valid? do
      Repo.insert(changeset)

    end
  end
  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 5)
  end
end
