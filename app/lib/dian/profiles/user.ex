defmodule Dian.Profiles.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles_users" do
    field :nickname, :string
    field :number, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:number, :nickname])
    |> validate_required([:number, :nickname])
  end
end
