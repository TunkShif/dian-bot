defmodule DianBot.Adapters.OnebotAdapterTest do
  use ExUnit.Case

  alias DianBot.BotError
  alias DianBot.Adapters.OnebotAdapter
  alias DianBot.Schemas.{User, Group, Message, Event}

  # mock data are located in /mock/data/*.json

  describe "OnebotAdapter.get_user/1" do
    test "returns user when given valid id" do
      assert {:ok, %User{} = user} = OnebotAdapter.get_user("1")
      assert user.qid == "1"
      assert user.nickname == "Alice"
    end

    test "returns not found when given invalid id" do
      assert {:error, %BotError{} = error} = OnebotAdapter.get_user("233")
      assert error.message == "not found"
    end
  end

  describe "OnebotAdapter.get_group/1" do
    test "returns group when given valid id" do
      assert {:ok, %Group{} = group} = OnebotAdapter.get_group("1")
      assert group.gid == "1"
    end

    test "returns not found when given invalid id" do
      assert {:error, %BotError{} = error} = OnebotAdapter.get_group("233")
      assert error.message == "not found"
    end
  end

  describe "OnebotAdapter.get_message/1" do
    test "returns message when given valid id" do
      assert {:ok, %Message{} = message} = OnebotAdapter.get_message("1")
      assert message.mid == "1"
      assert message.sender.nickname == "Alice"
      assert message.group.name == "Customer Support"
      assert message.raw_text == "Hello everyone!"
    end
  end

  describe "OnebotAdapter.get_forwarded_messages/1" do
    test "returns messages when given valid id" do
      assert {:ok, messages} = OnebotAdapter.get_forwarded_messages("1")
      assert length(messages) == 3
      assert message = List.first(messages)
      assert message.sender.nickname == "Alice"
      assert message.group.name == "Sales Team"
      assert message.raw_text =~ "Hey team"
    end
  end

  describe "OnebotAdapter.parse_event/2" do
    test "should fail when signature is nil" do
      event = event_fixature()
      payload = Jason.encode!(event)
      assert {:error, %BotError{} = error} = OnebotAdapter.parse_event(event, payload: payload)
      assert error.message == "unauthorized event source"
    end

    test "should fail when signature is invalid" do
      event = event_fixature()
      payload = Jason.encode!(event)

      assert {:error, %BotError{} = error} =
               OnebotAdapter.parse_event(event, payload: payload, signature: "sha1=foobar")

      assert error.message == "unauthorized event source"
    end

    test "should succeed when signature is valid" do
      event = event_fixature()
      payload = Jason.encode!(event)
      signature = :crypto.mac(:hmac, :sha, "1234", payload) |> Base.encode16(case: :lower)

      assert {:ok, %Event{} = event} =
               OnebotAdapter.parse_event(event, payload: payload, signature: "sha1=" <> signature)

      assert event.id == 666
      assert event.owner.qid == "9"
      assert event.group.gid == "3"
      assert event.message.mid == "1"
      assert event.message.raw_text == "Hello everyone!"
    end
  end

  defp event_fixature(mid \\ "1") do
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
  end
end
