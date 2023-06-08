defmodule Dian.FavoritesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dian.Favorites` context.
  """

  @doc """
  Generate a diaan.
  """
  def diaan_fixture(attrs \\ %{}) do
    {:ok, diaan} =
      attrs
      |> Enum.into(%{
        marked_at: ~N[2023-06-07 14:13:00]
      })
      |> Dian.Favorites.create_diaan()

    diaan
  end
end
