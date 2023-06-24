defmodule Dian.StatisticsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dian.Statistics` context.
  """

  @doc """
  Generate a hotword.
  """
  def hotword_fixture(attrs \\ %{}) do
    {:ok, hotword} =
      attrs
      |> Enum.into(%{
        keyword: "some keyword"
      })
      |> Dian.Statistics.create_hotword()

    hotword
  end
end
