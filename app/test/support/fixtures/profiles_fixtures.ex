defmodule Dian.ProfilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dian.Profiles` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        nickname: "some nickname",
        number: 42
      })
      |> Dian.Profiles.create_user()

    user
  end
end
