defmodule Dian.Interactions do
  @moduledoc """
  The Interactions context.
  """

  import Ecto.Query, warn: false

  alias Dian.Repo
  alias Dian.Interactions.Reaction

  @pubsub Dian.PubSub

  def topic(type), do: "interactions:#{type}"

  def subscribe(type) do
    Phoenix.PubSub.subscribe(@pubsub, topic(type))
  end

  def broadcast(type, message) do
    Phoenix.PubSub.broadcast(@pubsub, topic(type), message)
  end

  @doc """
  Returns the list of reactions.

  ## Examples

      iex> list_reactions()
      [%Reaction{}, ...]

  """
  def list_reactions do
    Repo.all(Reaction)
  end

  def get_reaction(diaan_id, user_id) do
    Repo.get_by(Reaction, diaan_id: diaan_id, user_id: user_id)
  end

  @doc """
  Gets a single reaction.

  Raises `Ecto.NoResultsError` if the Reaction does not exist.

  ## Examples

      iex> get_reaction!(123)
      %Reaction{}

      iex> get_reaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reaction!(id), do: Repo.get!(Reaction, id)

  @doc """
  Creates a reaction.

  ## Examples

      iex> create_reaction(%{field: value})
      {:ok, %Reaction{}}

      iex> create_reaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reaction(attrs \\ %{}) do
    with {:ok, reaction} <-
           %Reaction{}
           |> Reaction.changeset(attrs)
           |> Repo.insert() do
      diaan = Dian.Favorites.get_diaan!(reaction.diaan_id)
      diaan = diaan |> Repo.preload([:operator, :reactions, message: [:group, :sender]])
      broadcast("reaction", {:updated, diaan})

      {:ok, reaction}
    end
  end

  @doc """
  Updates a reaction.

  ## Examples

      iex> update_reaction(reaction, %{field: new_value})
      {:ok, %Reaction{}}

      iex> update_reaction(reaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reaction(%Reaction{} = reaction, attrs) do
    reaction
    |> Reaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reaction.

  ## Examples

      iex> delete_reaction(reaction)
      {:ok, %Reaction{}}

      iex> delete_reaction(reaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reaction(%Reaction{} = reaction) do
    Repo.delete(reaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reaction changes.

  ## Examples

      iex> change_reaction(reaction)
      %Ecto.Changeset{data: %Reaction{}}

  """
  def change_reaction(%Reaction{} = reaction, attrs \\ %{}) do
    Reaction.changeset(reaction, attrs)
  end
end
