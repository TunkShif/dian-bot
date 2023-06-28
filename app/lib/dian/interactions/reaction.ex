defmodule Dian.Interactions.Reaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reactions" do
    field :code, :string

    belongs_to :diaan, Dian.Favorites.Diaan
    belongs_to :user, Dian.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(reaction, attrs) do
    reaction
    |> cast(attrs, [:code, :diaan_id, :user_id])
    |> validate_required([:code, :diaan_id, :user_id])
    |> unique_constraint([:diaan_id, :user_id])
  end

  @emojis [
    {"ji", "🤣", "急"},
    {"xiao", "👴", "孝"},
    {"dian", "📕", "典"},
    {"le", "😋", "乐"},
    {"beng", "😅", "蚌"},
    {"ma", "😄", "麻"},
    {"ying", "🤗", "赢"},
    {"liu", "🤙", "六"}
  ]

  def emojis, do: @emojis

  def emoji("ji"), do: {"🤣", "急"}
  def emoji("xiao"), do: {"👴", "孝"}
  def emoji("dian"), do: {"📕", "典"}
  def emoji("le"), do: {"😋", "乐"}
  def emoji("beng"), do: {"😅", "蚌"}
  def emoji("ma"), do: {"😄", "麻"}
  def emoji("ying"), do: {"🤗", "赢"}
  def emoji("liu"), do: {"🤙", "六"}
  def emoji(_), do: {" ", ""}
end
