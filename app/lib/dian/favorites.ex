defmodule Dian.Favorites do
  @moduledoc """
  The Favorites context.
  """

  import Ecto.Query, warn: false
  alias Dian.Repo

  alias Dian.Favorites.Diaan

  def topic(group) do
    "diaan:#{group}"
  end

  def subscribe(group \\ "*") do
    Phoenix.PubSub.subscribe(Dian.PubSub, topic(group))
  end

  # TODO: event struct
  def broadcast(group \\ "*", payload) do
    Phoenix.PubSub.broadcast(Dian.PubSub, topic(group), payload)
  end

  def list_favorites_diaans(cursor \\ nil) do
    query =
      from d in Diaan,
        left_join: operator in assoc(d, :operator),
        left_join: message in assoc(d, :message),
        left_join: sender in assoc(message, :sender),
        left_join: group in assoc(message, :group),
        preload: [operator: operator, message: {message, sender: sender, group: group}],
        order_by: [desc: d.marked_at, desc: d.id]

    opts =
      Keyword.merge(
        [cursor_fields: [{:marked_at, :desc}, {:id, :desc}], limit: 20],
        if(cursor, do: [after: cursor], else: [])
      )

    %{entries: entries, metadata: metadata} = Repo.paginate(query, opts)

    {entries, metadata}
  end

  @doc """
  Gets a single diaan.

  Raises `Ecto.NoResultsError` if the Diaan does not exist.

  ## Examples

      iex> get_diaan!(123)
      %Diaan{}

      iex> get_diaan!(456)
      ** (Ecto.NoResultsError)

  """
  def get_diaan!(id), do: Repo.get!(Diaan, id)

  @doc """
  Creates a diaan.

  ## Examples

      iex> create_diaan(%{field: value})
      {:ok, %Diaan{}}

      iex> create_diaan(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_diaan(attrs \\ %{}) do
    %Diaan{}
    |> Diaan.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, diaan} ->
        diaan = diaan |> Repo.preload([:operator, message: [:group, :sender]])
        broadcast({:added, diaan})
        broadcast(diaan.message.group.number, {:added, diaan})
        {:ok, diaan}

      error ->
        error
    end
  end

  @doc """
  Updates a diaan.

  ## Examples

      iex> update_diaan(diaan, %{field: new_value})
      {:ok, %Diaan{}}

      iex> update_diaan(diaan, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_diaan(%Diaan{} = diaan, attrs) do
    diaan
    |> Diaan.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a diaan.

  ## Examples

      iex> delete_diaan(diaan)
      {:ok, %Diaan{}}

      iex> delete_diaan(diaan)
      {:error, %Ecto.Changeset{}}

  """
  def delete_diaan(%Diaan{} = diaan) do
    with {:ok, diaan} <- Repo.delete(diaan) do
      broadcast({:deleted, diaan})
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking diaan changes.

  ## Examples

      iex> change_diaan(diaan)
      %Ecto.Changeset{data: %Diaan{}}

  """
  def change_diaan(%Diaan{} = diaan, attrs \\ %{}) do
    Diaan.changeset(diaan, attrs)
  end
end
