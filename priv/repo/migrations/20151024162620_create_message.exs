defmodule ElixirChat.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :text
      add :user_id, references(:users)

      timestamps
    end
    create index(:messages, [:user_id])

  end
end
