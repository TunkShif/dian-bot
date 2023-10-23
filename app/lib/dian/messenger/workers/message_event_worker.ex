defmodule Dian.Messenger.MessageEventWorker do
  use Oban.Worker, max_attempts: 3, unique: [fields: [:args], keys: [:message]]

  alias Dian.{Messenger, Favorites}
  alias Dian.Messenger.{Client}

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"event" => event}}) do
    with {:ok, message} <- Messenger.import_message(event["message"]),
         {:ok, operator} <- Messenger.get_user(event["operator"]),
         attrs = %{
           marked_at: event["marked_at"],
           message_id: message.id,
           operator_id: operator.id
         },
         {:ok, diaan} <- Favorites.create_diaan(attrs) do
      diaan
    end

    # TODO
    Client.mark_message(event["message"])
    Client.send_message(event["group"], "[CQ:at,qq=#{event["operator"]}] 已入典")
  end
end
