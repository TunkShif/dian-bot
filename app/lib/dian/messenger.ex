defmodule Dian.Messenger do
  @moduledoc """
  The Messenger context.
  """

  require Logger

  import Ecto.Query, warn: false

  alias Dian.Repo
  alias Dian.Messenger.{Client, Message, User, Group}

  def get_message(number) do
    case Repo.get_by(Message, number: number) do
      nil -> {:error, :not_found}
      message -> {:ok, Repo.preload(message, [:sender, :group])}
    end
  end

  def import_message(number) do
    with {:ok, message} <- Client.fetch_message(number),
         {:ok, sender} <- get_user(message.sender),
         {:ok, group} <- get_group(message.group),
         {:ok, parsed_message} <- Message.Parser.parse(message.raw_content) do
      content = Message.Processor.process(parsed_message)
      raw_text = Message.Processor.raw_text(content)

      attrs =
        %{
          number: number,
          content: content,
          raw_text: raw_text,
          sent_at: message.sent_at,
          sender_id: sender.id,
          group_id: group.id
        }

      create_message(attrs)
    end
  end

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def get_user(number) do
    user = Repo.get_by(User, number: number)

    if user do
      {:ok, user}
    else
      import_user(number)
    end
  end

  def import_user(number) do
    with {:ok, user} <- Client.fetch_user(number) do
      user
      |> User.changeset(%{})
      |> Repo.insert()
    end
  end

  def get_group(number) do
    group = Repo.get_by(Group, number: number)

    if group do
      {:ok, group}
    else
      import_group(number)
    end
  end

  def import_group(number) do
    with {:ok, group} <- Client.fetch_group(number) do
      group
      |> Group.changeset(%{})
      |> Repo.insert()
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

  def list_messenger_users do
    Repo.all(User)
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
