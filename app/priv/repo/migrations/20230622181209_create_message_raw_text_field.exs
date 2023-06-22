defmodule Dian.Repo.Migrations.CreateMessageRawTextField do
  use Ecto.Migration

  def change do
    alter table(:messenger_messages) do
      add :raw_text, :string
    end
  end
end
