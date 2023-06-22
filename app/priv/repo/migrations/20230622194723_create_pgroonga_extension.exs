defmodule Dian.Repo.Migrations.CreatePgroongaExtension do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS pgroonga"
    execute "CREATE INDEX pgroonga_raw_text_index ON messenger_messages USING pgroonga (raw_text)"
  end
end
