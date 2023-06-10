defmodule Dian.Repo.Migrations.CreateMessengerGroups do
  use Ecto.Migration

  def change do
    create table(:messenger_groups) do
      add :name, :string
      add :number, :string, null: false

      timestamps()
    end

    create unique_index(:messenger_groups, [:number])
  end
end
