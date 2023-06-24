defmodule Dian.Repo.Migrations.CreateHotwords do
  use Ecto.Migration

  def change do
    create table(:hotwords) do
      add :keyword, :text

      timestamps()
    end
  end
end
