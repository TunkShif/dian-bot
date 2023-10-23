defmodule DianWeb.UserJSON do
  alias Dian.Messenger.User

  def index(%{users: users}) do
    %{
      data: many(users)
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
