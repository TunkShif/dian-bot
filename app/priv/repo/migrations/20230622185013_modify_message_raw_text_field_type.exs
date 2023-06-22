defmodule Dian.Repo.Migrations.ModifyMessageRawTextFieldType do
  use Ecto.Migration

  def change do
    alter table(:messenger_messages) do
      modify :raw_text, :text
    end
  end
end
