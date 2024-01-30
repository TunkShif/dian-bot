defmodule Dian.Repo.Migrations.CreateThreadsMessages do
  use Ecto.Migration

  def change do
    create table(:threads_messages, primary_key: false) do
      add :thread_id, references(:threads, on_delete: :nothing), null: false
      add :message_id, references(:messages, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create unique_index(:threads_messages, [:thread_id, :message_id])
  end
end
