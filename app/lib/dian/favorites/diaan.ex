defmodule Dian.Favorites.Diaan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "favorites_diaans" do
    field :marked_at, :naive_datetime

    has_many :reactions, Dian.Interactions.Reaction

    belongs_to :message, Dian.Messenger.Message
    belongs_to :operator, Dian.Profiles.User

    timestamps()
  end

  @doc false
  def changeset(diaan, attrs) do
    diaan
    |> cast(attrs, [:marked_at, :message_id, :operator_id])
    |> validate_required([:marked_at])
  end
end
