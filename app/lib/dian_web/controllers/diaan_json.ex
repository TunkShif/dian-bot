defmodule DianWeb.DiaanJSON do
  alias DianWeb.UserJSON
  alias DianWeb.MessageJSON
  alias Dian.Favorites.Diaan

  def index(%{diaans: diaans, metadata: metadata}) do
    %{
      data: %{
        entries: many(diaans),
        metadata: metadata
      }
    }
  end

  def show(%{diaan: diaan}) do
    %{data: one(diaan)}
  end

  def one(%Diaan{} = diaan) do
    diaan
    |> Map.take([:id, :marked_at])
    |> Map.merge(%{
      message: MessageJSON.one(diaan.message),
      operator: UserJSON.one(diaan.operator)
    })
  end

  def many(diaans) do
    Enum.map(diaans, &one/1)
  end
end
