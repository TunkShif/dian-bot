defmodule Dian.Messenger do
  @moduledoc """
  The Messenger context.
  """

  import Ecto.Query, warn: false

  require Logger

  alias Dian.QQ
  alias Dian.Repo
  alias Dian.Profiles
  alias Dian.Messenger.{Group, Message}
  alias Dian.QQ.{MessageParser, MessageProcessor}

  # TODO: refactor transaction
  def get_or_create_message(number) do
    if message = Repo.get_by(Message, number: "#{number}") do
      message
    else
      with {:ok, message} <- QQ.get_message(number),
           {:ok, parsed} <- MessageParser.parse(message.raw_content) do
        content = MessageProcessor.process(parsed)
        sender = Profiles.get_or_create_user(message.sender.number)
        group = get_or_create_group(message.group.number)

        {:ok, message} =
          Repo.insert(%Message{
            number: number,
            content: content,
            sent_at: message.sent_at,
            sender_id: sender.id,
            group_id: group.id
          })

        message
      else
        error ->
          Logger.error(error)
          nil
      end
    end
  end

  def get_or_create_group(number) do
    if group = Repo.get_by(Group, number: "#{number}") do
      group
    else
      with {:ok, group} <- QQ.get_group(number),
           {:ok, group} <- Repo.insert(struct(Group, group)) do
        group
      else
        error ->
          Logger.error(error)
          nil
      end
    end
  end

  @doc """
  Returns the list of messenger_groups.

  ## Examples

      iex> list_messenger_groups()
      [%Group{}, ...]

  """
  def list_messenger_groups do
    Repo.all(Group)
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id), do: Repo.get!(Group, id)

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{data: %Group{}}

  """
  def change_group(%Group{} = group, attrs \\ %{}) do
    Group.changeset(group, attrs)
  end

  @doc """
  Returns the list of messenger_messages.

  ## Examples

      iex> list_messenger_messages()
      [%Message{}, ...]

  """
  def list_messenger_messages do
    Repo.all(Message)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
