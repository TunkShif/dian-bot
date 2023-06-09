defmodule Dian.Statistics.Hotword do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hotwords" do
    field :keyword, :string

    timestamps()
  end

  @doc false
  def changeset(hotword, attrs) do
    hotword
    |> cast(attrs, [:keyword])
    |> validate_required([:keyword])
    |> validate_length(:keyword, max: 12)
  end
end
