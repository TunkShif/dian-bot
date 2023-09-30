defmodule DianWeb.DiaanJSON do
  alias Dian.Favorites.Diaan

  def index(%{diaans: diaans, metadata: metadata}) do
    %{
      data: %{
        entries: for(diaan <- diaans, do: Diaan.to_serializable(diaan)),
        metadata: metadata
      }
    }
  end

  def show(%{diaan: diaan}) do
    %{data: Diaan.to_serializable(diaan)}
  end
end
