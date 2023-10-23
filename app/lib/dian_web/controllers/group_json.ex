defmodule DianWeb.GroupJSON do
  alias Dian.Messenger.Group

  def index(%{groups: groups}) do
    %{
      data: many(groups)
    }
  end

  def one(%Group{} = group) do
    Map.take(group, [:id, :number, :name])
  end

  def many(groups) do
    Enum.map(groups, &one/1)
  end
end
