defmodule Dian.InteractionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dian.Interactions` context.
  """

  @doc """
  Generate a reaction.
  """
  def reaction_fixture(attrs \\ %{}) do
    {:ok, reaction} =
      attrs
      |> Enum.into(%{
        code: "some code"
      })
      |> Dian.Interactions.create_reaction()

    reaction
  end
end
