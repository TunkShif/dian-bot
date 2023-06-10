defmodule Dian.Events.QQEvent do
  import Dian.Helpers

  alias Dian.Events.QQEvent.GroupOperationEvent

  defmodule GroupOperationEvent do
    defstruct [:message, :group, :operator, :marked_at]
  end

  def from(%{"post_type" => "message", "message_type" => "group", "sub_type" => "normal"} = event) do
    %{
      "raw_message" => raw_content,
      "group_id" => group_number,
      "time" => marked_at,
      "sender" => %{"nickname" => operator_nickname, "user_id" => operator_number}
    } = event

    %{"message_id" => message_number} =
      Regex.named_captures(~r/\[CQ:reply,id=(?<message_id>-?\d+)\]/, raw_content)

    %GroupOperationEvent{
      message: %{
        number: message_number
      },
      group: %{
        number: group_number
      },
      operator: %{
        number: operator_number,
        nickname: operator_nickname
      },
      marked_at: convert_unix_timestamp!(marked_at)
    }
  end

  def from(_), do: nil
end
