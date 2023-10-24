defmodule Dian.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Dian.Repo
  alias Dian.Messenger
  alias Dian.Accounts.{User, UserToken, UserNotifier}

  def deliver_registration(id, url_fun) do
    messenger_profile = Repo.get(Messenger.User, id)

    unless messenger_profile.user_id do
      email = "#{messenger_profile.number}@qq.com"
      {encoded_token, user_token} = UserToken.build_email_token(email, "confirm")

      with {:ok, _user_token} <- Repo.insert(user_token),
           {:ok, _email} <-
             UserNotifier.deliver_confirmation_instructions(email, url_fun.(encoded_token)) do
        {:ok, messenger_profile}
      end
    else
      {:error, :exists}
    end
  end

  def verify_user_token(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
         %UserToken{} = user_token <- Repo.one(query),
         %{"number" => number} =
           Regex.named_captures(~r/(?<number>\d+)@qq\.com/, user_token.sent_to),
         %Messenger.User{} = messenger_profile <- Repo.get_by(Messenger.User, number: number) do
      unless messenger_profile.user_id do
        {:ok, messenger_profile}
      else
        {:error, :exists}
      end
    else
      nil -> {:error, :not_found}
      error -> error
    end
  end

  def register_user(token, attrs \\ {}) do
    with {:ok, messenger_profile} <- verify_user_token(token),
         {:ok, %{profile: user}} <-
           Ecto.Multi.new()
           |> Ecto.Multi.insert(:user, User.registration_changeset(%User{}, attrs))
           |> Ecto.Multi.update(:profile, fn %{user: user} ->
             Messenger.User.registration_changeset(messenger_profile, %{user_id: user.id})
           end)
           |> Repo.transaction() do
      {:ok, user}
    end
  end

  def get_user_by_password(id, password) when is_binary(password) do
    profile = Repo.get(Messenger.User, id) |> Repo.preload(:user)
    if User.valid_password?(profile.user, password), do: profile
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias Dian.Accounts.UserToken

  @doc """
  Returns the list of user_tokens.

  ## Examples

      iex> list_user_tokens()
      [%UserToken{}, ...]

  """
  def list_user_tokens do
    Repo.all(UserToken)
  end

  @doc """
  Gets a single user_token.

  Raises `Ecto.NoResultsError` if the User token does not exist.

  ## Examples

      iex> get_user_token!(123)
      %UserToken{}

      iex> get_user_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_token!(id), do: Repo.get!(UserToken, id)

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query) |> Repo.preload(:profile)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end
end
