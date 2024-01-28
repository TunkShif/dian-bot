defmodule DianBot.Coucou.Parser do
  import NimbleParsec

  comma = string(",")
  equal = string("=")
  closing = string("]")

  ident = ascii_string([?a..?z, ?A..?Z], min: 1)

  pair = ident |> ignore(equal) |> concat(utf8_string([not: ?,, not: ?]], min: 1)) |> wrap()

  pairs =
    choice([pair, ignore(comma)])
    |> repeat()
    |> map({List, :to_tuple, []})
    |> reduce({Map, :new, []})

  type = unwrap_and_tag(ident, :type)
  data = unwrap_and_tag(pairs, :data)

  code =
    ignore(string("[CQ:"))
    |> concat(type)
    |> ignore(comma)
    |> concat(data)
    |> concat(ignore(closing))
    |> reduce({Map, :new, []})

  text = utf8_string([{:not, ?[}, {:not, ?]}], min: 1) |> reduce({:wrap_text, []})

  message = choice([code, text]) |> repeat()

  defparsec(:parse, message)

  defp wrap_text([text]), do: %{type: "text", data: text}
end
