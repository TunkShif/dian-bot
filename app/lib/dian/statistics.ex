defmodule Dian.Statistics do
  @moduledoc """
  The Statistics context.
  """

  import Ecto.Query, warn: false

  alias Dian.Repo
  alias Dian.Statistics.Hotword

  @pubsub Dian.PubSub

  def topic(type), do: "statistics:#{type}"

  def subscribe(type) do
    Phoenix.PubSub.subscribe(@pubsub, topic(type))
  end

  def broadcast(type, message) do
    Phoenix.PubSub.broadcast(@pubsub, topic(type), message)
  end

  @doc """
  Returns the list of hotwords.

  ## Examples

      iex> list_hotwords()
      [%Hotword{}, ...]

  """
  def list_hotwords do
    Repo.all(from h in Hotword, order_by: [desc: h.updated_at, desc: h.id])
  end

  @doc """
  Creates a hotword.

  ## Examples

      iex> create_hotword(%{field: value})
      {:ok, %Hotword{}}

      iex> create_hotword(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_hotword(attrs) do
    existing_one = Repo.get_by(Hotword, keyword: attrs.keyword)

    result =
      if existing_one do
        existing_one
        |> Hotword.changeset(%{})
        |> Repo.update(force: true)
      else
        count = Repo.one(from h in Hotword, select: count())

        if count >= 15 do
          oldest = Repo.one(from h in Hotword, order_by: [desc: h.updated_at], limit: 1)
          Repo.delete!(oldest)
        end

        %Hotword{}
        |> Hotword.changeset(attrs)
        |> Repo.insert()
      end

    broadcast("hotword", "update:hotwords")

    result
  end
end
