defmodule Dian.Repo.Migrations.AddUserTokenSentToField do
  use Ecto.Migration

  def change do
    alter table(:user_tokens) do
      add :sent_to, :string
    end
  end
end
