defmodule DianWeb.UserJSON do
  alias Dian.Messenger.User

  def index(%{users: users}) do
    %{
      data: many(users)
    }
  end

  def show(%{user: user}) do
    %{
      data: one(user)
    }
  end

  def current(%{user: nil}) do
    %{
      data: nil
    }
  end

  def current(%{user: user}) do
    %{
      data: one(user.profile) |> Map.put(:role, user.role)
    }
  end

  def one(%User{} = user) do
    Map.take(user, [:id, :number, :nickname])
    |> Map.put(:avatar_url, "https://q.qlogo.cn/g?b=qq&nk=#{user.number}&s=100")
  end

  def many(users) do
    Enum.map(users, &one/1)
  end
end
