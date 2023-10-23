defmodule Dian.Messenger.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias Dian.Messenger.{User, Group}

  schema "messenger_messages" do
    field :content, {:array, :map}
    field :raw_text, :string
    field :number, :string
    field :sent_at, :naive_datetime

    belongs_to :sender, User
    belongs_to :group, Group

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:number, :content, :sent_at, :raw_text, :sender_id, :group_id])
    |> validate_required([:number, :content, :sent_at, :sender_id, :group_id])
  end
end
