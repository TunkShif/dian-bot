defmodule DianWeb.MessengerJSON do
  alias Dian.Messenger.Group
  alias Dian.Profiles.User

  def groups(%{groups: groups}) do
    %{data: for(group <- groups, do: Group.to_serializable(group))}
  end

  def users(%{users: users}) do
    %{data: for(user <- users, do: User.to_serializable(user))}
  end
end
