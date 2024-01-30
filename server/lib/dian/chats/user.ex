defmodule Dian.Chats.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Dian.Chats.Thread

  schema "users" do
    field :name, :string
    field :qid, :string

    has_many :threads, Thread, foreign_key: :owner_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:qid, :name])
    |> validate_required([:qid, :name])
  end
end
