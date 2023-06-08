defmodule Dian.ProfilesTest do
  use Dian.DataCase

  alias Dian.Profiles

  describe "profiles_users" do
    alias Dian.Profiles.User

    import Dian.ProfilesFixtures

    @invalid_attrs %{nickname: nil, number: nil}

    test "list_profiles_users/0 returns all profiles_users" do
      user = user_fixture()
      assert Profiles.list_profiles_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Profiles.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{nickname: "some nickname", number: 42}

      assert {:ok, %User{} = user} = Profiles.create_user(valid_attrs)
      assert user.nickname == "some nickname"
      assert user.number == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{nickname: "some updated nickname", number: 43}

      assert {:ok, %User{} = user} = Profiles.update_user(user, update_attrs)
      assert user.nickname == "some updated nickname"
      assert user.number == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Profiles.update_user(user, @invalid_attrs)
      assert user == Profiles.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Profiles.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Profiles.change_user(user)
    end
  end
end
