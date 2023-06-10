defmodule DianWeb.EventController do
  use DianWeb, :controller

  require Logger

  alias Dian.QQ
  alias Dian.Repo
  alias Dian.Profiles
  alias Dian.Messenger

  alias Dian.Favorites.Diaan
  alias Dian.Events.QQEvent
  alias Dian.Events.QQEvent.GroupOperationEvent

  # TODO: error handling

  def incoming(conn, params) do
    QQEvent.from(params)
    |> handle_event()
    |> case do
      {:ok, result} ->
        json(conn, %{success: true, message: result})

      error ->
        Logger.error(error)
        send_resp(conn, 500, %{success: false, message: "failed"})
    end
  end

  defp handle_event(%GroupOperationEvent{} = event) do
    %{message: message, group: group, operator: operator, marked_at: marked_at} = event

    message = Messenger.get_or_create_message(message.number)
    operator = Profiles.get_or_create_user(operator.number)

    QQ.set_essence_message(message.number)

    diaan =
      Repo.insert!(%Diaan{
        marked_at: marked_at,
        message_id: message.id,
        operator_id: operator.id
      })

    if diaan do
      QQ.send_group_message(group.number, "[CQ:at,qq=#{operator.number}] 已入典")

      {:ok, "success"}
    else
      {:error, "failed"}
    end
  end

  defp handle_event(nil), do: {:ok, "skipped"}
end
