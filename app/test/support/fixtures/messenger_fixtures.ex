defmodule Dian.MessengerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dian.Messenger` context.
  """

  @doc """
  Generate a group.
  """
  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        name: "some name",
        number: 42
      })
      |> Dian.Messenger.create_group()

    group
  end

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content",
        number: 42,
        sent_at: ~N[2023-06-07 14:09:00]
      })
      |> Dian.Messenger.create_message()

    message
  end
end
