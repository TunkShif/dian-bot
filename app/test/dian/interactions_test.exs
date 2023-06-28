defmodule Dian.InteractionsTest do
  use Dian.DataCase

  alias Dian.Interactions

  describe "reactions" do
    alias Dian.Interactions.Reaction

    import Dian.InteractionsFixtures

    @invalid_attrs %{code: nil}

    test "list_reactions/0 returns all reactions" do
      reaction = reaction_fixture()
      assert Interactions.list_reactions() == [reaction]
    end

    test "get_reaction!/1 returns the reaction with given id" do
      reaction = reaction_fixture()
      assert Interactions.get_reaction!(reaction.id) == reaction
    end

    test "create_reaction/1 with valid data creates a reaction" do
      valid_attrs = %{code: "some code"}

      assert {:ok, %Reaction{} = reaction} = Interactions.create_reaction(valid_attrs)
      assert reaction.code == "some code"
    end

    test "create_reaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Interactions.create_reaction(@invalid_attrs)
    end

    test "update_reaction/2 with valid data updates the reaction" do
      reaction = reaction_fixture()
      update_attrs = %{code: "some updated code"}

      assert {:ok, %Reaction{} = reaction} = Interactions.update_reaction(reaction, update_attrs)
      assert reaction.code == "some updated code"
    end

    test "update_reaction/2 with invalid data returns error changeset" do
      reaction = reaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Interactions.update_reaction(reaction, @invalid_attrs)
      assert reaction == Interactions.get_reaction!(reaction.id)
    end

    test "delete_reaction/1 deletes the reaction" do
      reaction = reaction_fixture()
      assert {:ok, %Reaction{}} = Interactions.delete_reaction(reaction)
      assert_raise Ecto.NoResultsError, fn -> Interactions.get_reaction!(reaction.id) end
    end

    test "change_reaction/1 returns a reaction changeset" do
      reaction = reaction_fixture()
      assert %Ecto.Changeset{} = Interactions.change_reaction(reaction)
    end
  end
end
