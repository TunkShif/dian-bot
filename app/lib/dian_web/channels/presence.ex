defmodule DianWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :dian,
    pubsub_server: Dian.PubSub

  @pubsub Dian.PubSub

  defp topic, do: "joined"

  def subscribe() do
    Phoenix.PubSub.subscribe(@pubsub, topic())
  end

  def join() do
    track(self(), topic(), Nanoid.generate(), %{})
  end

  def count() do
    list(topic())
    |> Enum.count()
  end
end
