defmodule Dian.Chats.Group do
  alias Dian.Chats.Thread
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :gid, :string
    field :name, :string
    field :description, :string

    has_many :threads, Thread

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:gid, :name, :description])
    |> validate_required([:gid, :name, :description])
  end
end
