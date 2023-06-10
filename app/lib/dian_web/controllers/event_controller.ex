defmodule DianWeb.EventController do
  use DianWeb, :controller

  alias Dian.Favorites.Diaan
  alias Dian.QQ
  alias Dian.Repo
  alias Dian.Profiles.User
  alias Dian.Messenger.{Group, Message}

  def incoming(conn, params) do
    case handle_event(params) do
      {:ok, status} ->
        send_resp(conn, 200, "#{status}")

      {:error, reason} ->
        # TODO
        send_resp(conn, 500, "#{reason}")
    end
  end

  # TODO: refactor
  # TODO: support image/at/etc.
  defp handle_event(%{"message_type" => "group"} = event) do
    %{
      "raw_message" => message,
      "group_id" => group_id,
      "time" => marked_at,
      "sender" => %{"nickname" => operator_nickname, "user_id" => operator_number}
    } = event

    captured = Regex.named_captures(~r/\[CQ:reply,id=(?<message_id>-?\d+)\]/, message)

    with %{"message_id" => message_id} <- captured,
         {:ok, message} <- QQ.get_message_by_id(message_id),
         {:ok, group} <- QQ.get_group_by_id(group_id) do
      %{
        "group_id" => group_number,
        "group_name" => group_name
      } = group

      %{
        "message_id" => message_number,
        "message" => content,
        "time" => sent_at,
        "sender" => %{"nickname" => sender_nickname, "user_id" => sender_number}
      } = message

      user =
        Repo.get_by(User, number: sender_number) ||
          Repo.insert!(%User{number: sender_number, nickname: sender_nickname})

      operator =
        Repo.get_by(User, number: operator_number) ||
          Repo.insert!(%User{number: operator_number, nickname: operator_nickname})

      group =
        Repo.get_by(Group, number: group_number) ||
          Repo.insert!(%Group{number: group_number, name: group_name})

      sent_at = sent_at |> DateTime.from_unix!() |> DateTime.to_naive()
      marked_at = marked_at |> DateTime.from_unix!() |> DateTime.to_naive()

      message =
        Repo.insert!(%Message{
          number: message_number,
          content: content,
          sent_at: sent_at,
          sender_id: user.id,
          group_id: group.id
        })

      _diaan =
        Repo.insert!(%Diaan{
          message_id: message.id,
          operator_id: operator.id,
          marked_at: marked_at
        })

      QQ.set_essence_msg(message.number)
      QQ.send_group_msg(group_number, "[CQ:at,qq=#{operator_number}] 已入典")

      {:ok, :ok}
    else
      error ->
        # TODO
        dbg(error)
        {:error, :unknown}
    end
  end

  defp handle_event(_) do
    # TODO
    {:ok, :skipped}
  end
end
