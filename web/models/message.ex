defmodule ElixirChat.Message do
  use ElixirChat.Web, :model

  schema "messages" do
    field :content, :string
    belongs_to :user, ElixirChat.User, foreign_key: :user_id

    timestamps
  end

  @required_fields ~w(content)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
