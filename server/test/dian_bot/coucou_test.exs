defmodule DianBot.CoucouTest do
  use ExUnit.Case

  alias DianBot.Coucou

  doctest DianBot.Coucou

  test "should parse text message" do
    result = Coucou.parse_message("foobar")

    assert match?(
             [
               %{type: "text", data: "foobar"}
             ],
             result
           )
  end

  test "should parse CQ code" do
    result = Coucou.parse_message("[CQ:at,qq=123]")

    assert match?(
             [
               %{type: "at", data: %{"qq" => "123"}}
             ],
             result
           )
  end

  test "should parse text with CQ code" do
    result = Coucou.parse_message("[CQ:reply,id=123,text=hello]foobar")

    assert match?(
             [
               %{type: "reply", data: %{"id" => "123", "text" => "hello"}},
               %{type: "text", data: "foobar"}
             ],
             result
           )
  end
end
