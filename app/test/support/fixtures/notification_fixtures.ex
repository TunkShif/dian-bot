defmodule Dian.NotificationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dian.Notification` context.
  """

  @doc """
  Generate a subscription.
  """
  def subscription_fixture(attrs \\ %{}) do
    {:ok, subscription} =
      attrs
      |> Enum.into(%{
        endpoint: "some endpoint",
        subscription: %{}
      })
      |> Dian.Notification.create_subscription()

    subscription
  end
end
