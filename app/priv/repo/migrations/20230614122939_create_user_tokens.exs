defmodule Dian.Repo.Migrations.CreateUserTokens do
  use Ecto.Migration

  def change do
    create table(:user_tokens) do
      add :token, :binary
      add :context, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(updated_at: false)
    end

    create index(:user_tokens, [:user_id])
  end
end
