defmodule Dian.Chats.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  alias Dian.Chats.{User, Group, Message}

  schema "threads" do
    field :posted_at, :naive_datetime

    belongs_to :owner, User
    belongs_to :group, Group

    many_to_many :messages, Message, join_through: "threads_messages", unique: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:posted_at])
    |> validate_required([:posted_at])
  end
end
