defmodule Dian.Repo.Migrations.CreateReactions do
  use Ecto.Migration

  def change do
    create table(:reactions) do
      add :code, :string
      add :diaan_id, references(:favorites_diaans, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:reactions, [:diaan_id, :user_id])
  end
end
