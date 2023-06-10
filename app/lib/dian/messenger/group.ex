defmodule Dian.Messenger.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messenger_groups" do
    field :name, :string
    field :number, :string

    has_many :messages, Dian.Messenger.Message

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :number])
    |> validate_required([:name, :number])
  end
end
