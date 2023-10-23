defmodule Dian.Messenger.Event do
  import Dian.Helpers

  @type t() :: map()

  @derive Jason.Encoder
  defstruct [:message, :group, :operator, :marked_at]

  def parse(%{"post_type" => "message", "message_type" => "group"} = data) do
    %{
      "raw_message" => raw_content,
      "group_id" => group_number,
      "time" => marked_at,
      "sender" => %{"user_id" => operator_number}
    } = data

    %{"message_id" => message_number} =
      Regex.named_captures(~r/\[CQ:reply,id=(?<message_id>-?\d+)\]/, raw_content)

    event = %__MODULE__{
      message: "#{message_number}",
      group: "#{group_number}",
      operator: "#{operator_number}",
      marked_at: convert_unix_timestamp!(marked_at)
    }

    {:ok, event}
  end

  def parse(_), do: {:error, :unknown_event}
end
