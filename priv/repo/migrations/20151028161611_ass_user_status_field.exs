defmodule ElixirChat.Repo.Migrations.AssUserStatusField do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :online, :boolean
    end
  end
end
