defmodule Dian.Repo.Migrations.CreateMessageIndex do
  use Ecto.Migration

  def change do
    create index(:favorites_diaans, [:marked_at, :id])
  end
end
