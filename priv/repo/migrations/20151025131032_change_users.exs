defmodule ElixirChat.Repo.Migrations.ChangeUsers do
  use Ecto.Migration

  def change do
  	alter table(:users) do
      add :provider, :string
      add :oauth_token, :string
      add :oauth_expires_at, :string
    end

    rename table(:users), :fb_id, to: :uid
    rename table(:users), :fb_img, to: :image
    rename table(:users), :fb_mail, to: :email
  end
end
