defmodule Dian.Repo.Migrations.CreateFavoritesDiaans do
  use Ecto.Migration

  def change do
    create table(:favorites_diaans) do
      add :marked_at, :naive_datetime
      add :message_id, references(:profiles_users, on_delete: :nothing)
      add :operator_id, references(:profiles_users, on_delete: :nothing)

      timestamps()
    end

    create index(:favorites_diaans, [:message_id])
    create index(:favorites_diaans, [:operator_id])
  end
end
