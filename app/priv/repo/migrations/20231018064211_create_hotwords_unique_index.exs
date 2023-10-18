defmodule Dian.Repo.Migrations.CreateHotwordsUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:hotwords, [:keyword])
  end
end
