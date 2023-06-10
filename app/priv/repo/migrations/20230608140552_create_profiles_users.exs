defmodule Dian.Repo.Migrations.CreateProfilesUsers do
  use Ecto.Migration

  def change do
    create table(:profiles_users) do
      add :number, :string, null: false
      add :nickname, :string

      timestamps()
    end

    create unique_index(:profiles_users, [:number])
  end
end
