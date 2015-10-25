defmodule ElixirChat.Repo.Migrations.ChangeExpiresType do
  use Ecto.Migration

  def change do
  	alter table(:users) do
      modify :oauth_expires_at, :integer
    end
  end
end
