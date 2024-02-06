defmodule DianBot.CoucouTest do
  use ExUnit.Case

  alias DianBot.Coucou

  doctest DianBot.Coucou

  test "should parse text message" do
    assert [%{type: "text", data: "foobar"}] = Coucou.parse_message("foobar")
  end

  test "should parse CQ code" do
    assert [%{type: "at", data: %{"qq" => "123"}}] = Coucou.parse_message("[CQ:at,qq=123]")
  end

  test "should parse text with CQ code" do
    assert [
             %{type: "reply", data: %{"id" => "123", "text" => "hello"}},
             %{type: "text", data: "foobar"}
           ] = Coucou.parse_message("[CQ:reply,id=123,text=hello]foobar")
  end
end
