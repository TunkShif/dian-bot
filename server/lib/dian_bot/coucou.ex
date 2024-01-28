defmodule DianBot.Coucou do
  @moduledoc """
  Message parser with CQ code support.
  """

  @doc ~S"""
  Parse a message text containing CQ code.

  ## Examples
      iex> DianBot.Coucou.parse_message("[CQ:at,qq=8964]foobar")
      [%{type: "at", data: %{"qq" => "8964"}}, %{type: "text", data: "foobar"}]
  """
  def parse_message(source) do
    {:ok, result, _rest, _context, _position, _byte_offset} = DianBot.Coucou.Parser.parse(source)
    result
  end
end
