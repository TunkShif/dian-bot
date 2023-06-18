defmodule Dian.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :hashed_password, :string
      add :role, :string, default: "user"

      timestamps()
    end

    alter table(:profiles_users) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:profiles_users, [:user_id])
  end
end
