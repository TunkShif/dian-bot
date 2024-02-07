defmodule Dian.Fixtures do
  alias DianBot.Schemas.Event

  def fixture(type, opts \\ [])

  def fixture(:raw_event, opts) do
    mid = opts[:mid] || "1"

    %{
      "message_type" => "group",
      "sub_type" => "group",
      "message_id" => 666,
      "group_id" => 3,
      "raw_message" => "[CQ:reply,id=#{mid}]/mk",
      "sender" => %{
        "user_id" => 9
      },
      "time" => 1_644_180_000
    }
    |> Jason.encode!()
  end

  def fixture(:event, opts) do
    id = opts[:id] || 666
    qid = opts[:qid] || "9"
    gid = opts[:gid] || "3"
    mid = opts[:mid] || "1"

    {:ok, owner} = DianBot.get_user(qid)
    {:ok, group} = DianBot.get_group(gid)
    {:ok, message} = DianBot.get_message(mid)

    %Event{
      id: id,
      marked_at: ~U[2022-02-06 20:40:00Z],
      group: group,
      owner: owner,
      message: message
    }
  end
end
