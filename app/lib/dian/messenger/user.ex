defmodule Dian.Messenger.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles_users" do
    field :nickname, :string
    field :number, :string

    belongs_to :user, Dian.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:number, :nickname, :user_id])
    |> validate_required([:number, :nickname])
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
