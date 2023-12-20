defmodule Dian.Messenger.MessageEventWorker do
  use Oban.Worker, max_attempts: 3, unique: [fields: [:args], keys: [:message]]

  alias Dian.{Messenger, Favorites, Notification}
  alias Dian.Notification.MessageNotificationWorker

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"event" => event}}) do
    diaan =
      with {:ok, message} <- Messenger.import_message(event["message"]),
           {:ok, operator} <- Messenger.get_user(event["operator"]),
           attrs = %{
             marked_at: event["marked_at"],
             message_id: message.id,
             operator_id: operator.id
           },
           {:ok, diaan} <- Favorites.create_diaan(attrs) do
        # TODO
        for %{subscription: subscription} <- Notification.list_notification_subscriptions() do
          MessageNotificationWorker.new(%{
            subscription: subscription,
            message: message.id,
            endpoint: subscription["endpoint"]
          })
          |> Oban.insert()
        end

        diaan
      end

    # TODO
    Messenger.Client.mark_message(event["message"])

    Messenger.Client.send_message(
      event["group"],
      "[CQ:at,qq=#{event["operator"]}] 已入典 (https://dian.tunkshif.one/archive/#{diaan.id})"
    )
  end
end
