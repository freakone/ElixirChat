defmodule ElixirChat.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :fb_id, :integer
      add :fb_img, :string
      add :fb_mail, :string

      timestamps
    end

  end
end
