defmodule ElixirChat.Message do
  use ElixirChat.Web, :model

  schema "messages" do
    field :content, :string
    belongs_to :user, ElixirChat.User, foreign_key: :user_id

    timestamps
  end

  @required_fields ~w(content user_id)
  @optional_fields ~w()

  def with_user(query) do
    from q in query, preload: [user: :name]
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:content, min: 1)
    |> validate_number(:user_id, greater_than: 0)
  end
end
