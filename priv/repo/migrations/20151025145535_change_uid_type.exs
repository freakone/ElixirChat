defmodule ElixirChat.Repo.Migrations.ChangeUidType do
  use Ecto.Migration

  def change do
  	alter table(:users) do
      modify :uid, :bigint
    end
  end
end
