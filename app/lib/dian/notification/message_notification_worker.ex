defmodule Dian.Notification.MessageNotificationWorker do
  use Oban.Worker, max_attempts: 3, unique: [fields: [:args], keys: [:endpoint]]

  alias Dian.{Repo, WebPush}
  alias Dian.Messenger.Message
  alias DianWeb.MessageJSON

  @impl Oban.Worker
  def perform(%Oban.Job{
        args: %{"subscription" => subscription, "message" => message}
      }) do
    message = Repo.get(Message, message) |> Repo.preload([:sender, :group])

    payload =
      Jason.encode!(%{
        message: message |> MessageJSON.one()
      })

    WebPush.send_notification(subscription, payload)
  end
end
