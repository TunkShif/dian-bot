defmodule Dian.Favorites do
  @moduledoc """
  The Favorites context.
  """

  import Ecto.Query, warn: false
  alias Dian.Repo

  alias Dian.Favorites.Diaan

  def list_favorites_diaans(params \\ %{}) do
    filters =
      if group_id = params["group"] do
        dynamic([d, operator, message], message.group_id == ^group_id)
      else
        true
      end

    filters =
      if sender_id = params["sender"] do
        dynamic([d, operator, message], ^filters and message.sender_id == ^sender_id)
      else
        filters
      end

    filters =
      if date = params["date"] do
        date = Date.from_iso8601!(date)
        dynamic([d, operator, message], ^filters and fragment("DATE(?) = ?", d.marked_at, ^date))
      else
        filters
      end

    filters =
      if keyword = params["keyword"] do
        dynamic(
          [d, operator, message],
          ^filters and fragment("? &@~ ?", message.raw_text, ^keyword)
        )
      else
        filters
      end

    query =
      from d in Diaan,
        left_join: operator in assoc(d, :operator),
        inner_join: message in assoc(d, :message),
        left_join: sender in assoc(message, :sender),
        left_join: group in assoc(message, :group),
        left_join: reactions in assoc(d, :reactions),
        preload: [
          operator: operator,
          message: {message, sender: sender, group: group},
          reactions: reactions
        ],
        where: ^filters,
        order_by: [desc: d.marked_at, desc: d.id],
        select: d

    params =
      if page = params["page"] do
        [page: page]
      else
        []
      end

    page = Repo.paginate(query, params)
    entries = page.entries
    metadata = page |> Map.drop([:__struct__, :entries])

    {entries, metadata}
  end

  def list_favorites_images(params) do
    query =
      from d in Diaan,
        left_join: operator in assoc(d, :operator),
        inner_join: message in assoc(d, :message),
        left_join: sender in assoc(message, :sender),
        left_join: group in assoc(message, :group),
        left_join: reactions in assoc(d, :reactions),
        preload: [
          operator: operator,
          message: {message, sender: sender, group: group},
          reactions: reactions
        ],
        where: is_nil(message.raw_text) or message.raw_text == "",
        order_by: [desc: d.marked_at, desc: d.id],
        select: d

    page = Repo.paginate(query, params)
    entries = page.entries
    metadata = page |> Map.drop([:__struct__, :entries])

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

  def get_diaan(id) do
    query =
      from d in Diaan,
        left_join: operator in assoc(d, :operator),
        inner_join: message in assoc(d, :message),
        left_join: sender in assoc(message, :sender),
        left_join: group in assoc(message, :group),
        left_join: reactions in assoc(d, :reactions),
        preload: [
          operator: operator,
          message: {message, sender: sender, group: group},
          reactions: reactions
        ],
        where: d.id == ^id,
        select: d

    Repo.one(query)
  end

  def get_diaan_by_message_id(id) do
    Repo.get(Diaan, message_id: id)
  end

  def list_favorites_feeds(date) do
    query =
      from d in Diaan,
        inner_join: m in assoc(d, :message),
        left_join: s in assoc(m, :sender),
        preload: [message: {m, sender: s}],
        where: fragment("DATE(?) = ?", d.marked_at, ^date),
        order_by: [desc: d.marked_at, desc: d.id],
        select: d

    Repo.all(query)
  end

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
        diaan = diaan |> Repo.preload([:operator, :reactions, message: [:group, :sender]])
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
  def delete_diaan(id) do
    diaan = Repo.get(Diaan, id)

    if diaan do
      Repo.delete(diaan)
    else
      {:error, :not_found}
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
