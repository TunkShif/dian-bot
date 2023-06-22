defmodule Dian.Repo.Migrations.CreateDiannUniqueIndex do
  use Ecto.Migration

  def change do
    drop index(:favorites_diaans, [:message_id])
    create unique_index(:favorites_diaans, [:message_id])
  end
end
