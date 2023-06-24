defmodule Dian.StatisticsTest do
  use Dian.DataCase

  alias Dian.Statistics

  describe "hotwords" do
    alias Dian.Statistics.Hotword

    import Dian.StatisticsFixtures

    @invalid_attrs %{keyword: nil}

    test "list_hotwords/0 returns all hotwords" do
      hotword = hotword_fixture()
      assert Statistics.list_hotwords() == [hotword]
    end

    test "get_hotword!/1 returns the hotword with given id" do
      hotword = hotword_fixture()
      assert Statistics.get_hotword!(hotword.id) == hotword
    end

    test "create_hotword/1 with valid data creates a hotword" do
      valid_attrs = %{keyword: "some keyword"}

      assert {:ok, %Hotword{} = hotword} = Statistics.create_hotword(valid_attrs)
      assert hotword.keyword == "some keyword"
    end

    test "create_hotword/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Statistics.create_hotword(@invalid_attrs)
    end

    test "update_hotword/2 with valid data updates the hotword" do
      hotword = hotword_fixture()
      update_attrs = %{keyword: "some updated keyword"}

      assert {:ok, %Hotword{} = hotword} = Statistics.update_hotword(hotword, update_attrs)
      assert hotword.keyword == "some updated keyword"
    end

    test "update_hotword/2 with invalid data returns error changeset" do
      hotword = hotword_fixture()
      assert {:error, %Ecto.Changeset{}} = Statistics.update_hotword(hotword, @invalid_attrs)
      assert hotword == Statistics.get_hotword!(hotword.id)
    end

    test "delete_hotword/1 deletes the hotword" do
      hotword = hotword_fixture()
      assert {:ok, %Hotword{}} = Statistics.delete_hotword(hotword)
      assert_raise Ecto.NoResultsError, fn -> Statistics.get_hotword!(hotword.id) end
    end

    test "change_hotword/1 returns a hotword changeset" do
      hotword = hotword_fixture()
      assert %Ecto.Changeset{} = Statistics.change_hotword(hotword)
    end
  end
end
