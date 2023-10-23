defmodule DianWeb.MessageJSON do
  alias Dian.Messenger.{Message}
  alias DianWeb.{UserJSON, GroupJSON}

  def show(%{message: message}) do
    %{data: one(message)}
  end

  def one(%Message{} = message) do
    message
    |> Map.take([:id, :number, :content, :sent_at])
    |> Map.merge(%{
      sender: UserJSON.one(message.sender),
      group: GroupJSON.one(message.group)
    })
  end
end
