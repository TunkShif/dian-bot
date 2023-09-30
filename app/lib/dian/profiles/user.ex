defmodule Dian.Profiles.User do
  alias Dian.QQ
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

  def to_serializable(%__MODULE__{} = user) do
    %{
      id: user.id,
      nickname: user.nickname,
      number: user.number,
      avatar_url: QQ.get_user_avator_by_number(user.number)
    }
  end
end
