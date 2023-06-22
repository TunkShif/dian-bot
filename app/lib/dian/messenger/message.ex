defmodule Dian.Messenger.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messenger_messages" do
    field :content, {:array, :map}
    field :raw_text, :string
    field :number, :string
    field :sent_at, :naive_datetime

    belongs_to :sender, Dian.Profiles.User
    belongs_to :group, Dian.Messenger.Group

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:number, :content, :sent_at, :raw_text])
    |> validate_required([:number, :content, :sent_at])
  end
end
