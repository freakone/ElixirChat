defmodule ElixirChat.Repo.Migrations.OnlineToNumber do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :online
      add :online, :integer
    end
  end
end
