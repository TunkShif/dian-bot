defmodule Dian.MessengerTest do
  use Dian.DataCase

  alias Dian.Messenger

  describe "messenger_groups" do
    alias Dian.Messenger.Group

    import Dian.MessengerFixtures

    @invalid_attrs %{name: nil, number: nil}

    test "list_messenger_groups/0 returns all messenger_groups" do
      group = group_fixture()
      assert Messenger.list_messenger_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert Messenger.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      valid_attrs = %{name: "some name", number: 42}

      assert {:ok, %Group{} = group} = Messenger.create_group(valid_attrs)
      assert group.name == "some name"
      assert group.number == 42
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messenger.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()
      update_attrs = %{name: "some updated name", number: 43}

      assert {:ok, %Group{} = group} = Messenger.update_group(group, update_attrs)
      assert group.name == "some updated name"
      assert group.number == 43
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = Messenger.update_group(group, @invalid_attrs)
      assert group == Messenger.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = Messenger.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Messenger.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = Messenger.change_group(group)
    end
  end

  describe "messenger_messages" do
    alias Dian.Messenger.Message

    import Dian.MessengerFixtures

    @invalid_attrs %{content: nil, number: nil, sent_at: nil}

    test "list_messenger_messages/0 returns all messenger_messages" do
      message = message_fixture()
      assert Messenger.list_messenger_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Messenger.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{content: "some content", number: 42, sent_at: ~N[2023-06-07 14:09:00]}

      assert {:ok, %Message{} = message} = Messenger.create_message(valid_attrs)
      assert message.content == "some content"
      assert message.number == 42
      assert message.sent_at == ~N[2023-06-07 14:09:00]
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messenger.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()

      update_attrs = %{
        content: "some updated content",
        number: 43,
        sent_at: ~N[2023-06-08 14:09:00]
      }

      assert {:ok, %Message{} = message} = Messenger.update_message(message, update_attrs)
      assert message.content == "some updated content"
      assert message.number == 43
      assert message.sent_at == ~N[2023-06-08 14:09:00]
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Messenger.update_message(message, @invalid_attrs)
      assert message == Messenger.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Messenger.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messenger.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Messenger.change_message(message)
    end
  end
end
