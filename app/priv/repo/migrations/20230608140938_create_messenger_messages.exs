defmodule Dian.Repo.Migrations.CreateMessengerMessages do
  use Ecto.Migration

  def change do
    create table(:messenger_messages) do
      add :number, :string
      add :content, {:array, :json}
      add :sent_at, :naive_datetime
      add :sender_id, references(:profiles_users, on_delete: :nothing)
      add :group_id, references(:messenger_groups, on_delete: :nothing)

      timestamps()
    end

    create index(:messenger_messages, [:sender_id])
    create index(:messenger_messages, [:group_id])
  end
end
