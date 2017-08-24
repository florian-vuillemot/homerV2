defmodule Homer.InvestsTest do
  use Homer.DataCase

  alias Homer.Invests

  describe "investors" do
    alias Homer.Invests.Investor

    @valid_attrs %{comment: "some comment"}
    @update_attrs %{comment: "some updated comment"}
    @invalid_attrs %{comment: nil}

    def investor_fixture(attrs \\ %{}) do
      {:ok, investor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Invests.create_investor()

      investor
    end

    test "list_investors/0 returns all investors" do
      investor = investor_fixture()
      assert Invests.list_investors() == [investor]
    end

    test "get_investor!/1 returns the investor with given id" do
      investor = investor_fixture()
      assert Invests.get_investor!(investor.id) == investor
    end

    test "create_investor/1 with valid data creates a investor" do
      assert {:ok, %Investor{} = investor} = Invests.create_investor(@valid_attrs)
      assert investor.comment == "some comment"
      assert investor.steps_validation == []
    end

    test "create_investor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Invests.create_investor(@invalid_attrs)
    end

    test "update_investor/2 with valid data updates the investor" do
      investor = investor_fixture()
      assert {:ok, investor} = Invests.update_investor(investor, @update_attrs)
      assert %Investor{} = investor
      assert investor.comment == "some updated comment"
      assert investor.steps_validation == []
    end

    test "update_investor/2 with invalid data returns error changeset" do
      investor = investor_fixture()
      assert {:error, %Ecto.Changeset{}} = Invests.update_investor(investor, @invalid_attrs)
      assert investor == Invests.get_investor!(investor.id)
    end

    test "delete_investor/1 deletes the investor" do
      investor = investor_fixture()
      assert {:ok, %Investor{}} = Invests.delete_investor(investor)
      assert_raise Ecto.NoResultsError, fn -> Invests.get_investor!(investor.id) end
    end

    test "change_investor/1 returns a investor changeset" do
      investor = investor_fixture()
      assert %Ecto.Changeset{} = Invests.change_investor(investor)
    end
  end
end
