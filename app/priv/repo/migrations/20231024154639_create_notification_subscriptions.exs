defmodule Dian.Repo.Migrations.CreateNotificationSubscriptions do
  use Ecto.Migration

  def change do
    create table(:notification_subscriptions) do
      add :endpoint, :string
      add :subscription, :map
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:notification_subscriptions, [:user_id])
    create unique_index(:notification_subscriptions, [:endpoint])
  end
end
