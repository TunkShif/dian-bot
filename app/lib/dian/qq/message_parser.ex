defmodule Dian.QQ.MessageParser do
  import NimbleParsec

  ident = ascii_string([?a..?z, ?A..?Z], min: 1)

  pair =
    ident
    |> concat(ignore(string("=")))
    |> concat(utf8_string([{:not, ?,}, {:not, ?]}], min: 1))
    |> wrap()

  pairs =
    choice([
      pair,
      ignore(string(","))
    ])
    |> repeat()
    |> wrap()

  code =
    ignore(string("[CQ:"))
    |> concat(ident)
    |> concat(ignore(string(",")))
    |> concat(pairs)
    |> concat(ignore(string("]")))
    |> tag(:code)

  text = utf8_string([{:not, ?[}, {:not, ?]}], min: 1) |> tag(:text)

  message =
    choice([
      code,
      text
    ])
    |> repeat()

  defparsec(:message, message)

  def parse(raw_content) when is_binary(raw_content) do
    with {:ok, parts, _, _, _, _} <- message(raw_content) do
      content =
        Enum.map(parts, fn
          {:text, [text]} ->
            %{"type" => "text", "data" => text}

          {:code, [type, pairs]} ->
            %{"type" => type, "data" => for([key, val] <- pairs, do: {key, val}, into: %{})}
        end)

      {:ok, content}
    end
  end
end
