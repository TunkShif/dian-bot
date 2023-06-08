defmodule Dian.FavoritesTest do
  use Dian.DataCase

  alias Dian.Favorites

  describe "favorites_diaans" do
    alias Dian.Favorites.Diaan

    import Dian.FavoritesFixtures

    @invalid_attrs %{marked_at: nil}

    test "list_favorites_diaans/0 returns all favorites_diaans" do
      diaan = diaan_fixture()
      assert Favorites.list_favorites_diaans() == [diaan]
    end

    test "get_diaan!/1 returns the diaan with given id" do
      diaan = diaan_fixture()
      assert Favorites.get_diaan!(diaan.id) == diaan
    end

    test "create_diaan/1 with valid data creates a diaan" do
      valid_attrs = %{marked_at: ~N[2023-06-07 14:13:00]}

      assert {:ok, %Diaan{} = diaan} = Favorites.create_diaan(valid_attrs)
      assert diaan.marked_at == ~N[2023-06-07 14:13:00]
    end

    test "create_diaan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Favorites.create_diaan(@invalid_attrs)
    end

    test "update_diaan/2 with valid data updates the diaan" do
      diaan = diaan_fixture()
      update_attrs = %{marked_at: ~N[2023-06-08 14:13:00]}

      assert {:ok, %Diaan{} = diaan} = Favorites.update_diaan(diaan, update_attrs)
      assert diaan.marked_at == ~N[2023-06-08 14:13:00]
    end

    test "update_diaan/2 with invalid data returns error changeset" do
      diaan = diaan_fixture()
      assert {:error, %Ecto.Changeset{}} = Favorites.update_diaan(diaan, @invalid_attrs)
      assert diaan == Favorites.get_diaan!(diaan.id)
    end

    test "delete_diaan/1 deletes the diaan" do
      diaan = diaan_fixture()
      assert {:ok, %Diaan{}} = Favorites.delete_diaan(diaan)
      assert_raise Ecto.NoResultsError, fn -> Favorites.get_diaan!(diaan.id) end
    end

    test "change_diaan/1 returns a diaan changeset" do
      diaan = diaan_fixture()
      assert %Ecto.Changeset{} = Favorites.change_diaan(diaan)
    end
  end
end
