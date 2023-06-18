defmodule Dian.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dian.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        hased_password: "some hased_password",
        role: "some role"
      })
      |> Dian.Accounts.create_user()

    user
  end

  @doc """
  Generate a user_token.
  """
  def user_token_fixture(attrs \\ %{}) do
    {:ok, user_token} =
      attrs
      |> Enum.into(%{
        context: "some context",
        token: "some token"
      })
      |> Dian.Accounts.create_user_token()

    user_token
  end
end
