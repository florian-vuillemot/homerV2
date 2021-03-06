defmodule Homer.InvestsAllowsTest do
  use Homer.DataCase

  alias Homer.InvestsAllows

  describe "invests_allows" do
    alias Homer.InvestsAllows.InvestAllow

    @valid_attrs %{description: "some description", invest: 21, name: "some name"}
    @update_attrs %{description: "some updated description", invest: 43, name: "some updated name"}
    @invalid_attrs %{description: nil, invest: nil, name: nil}

    def invest_allow_fixture(attrs \\ %{}) do
      {:ok, invest_allow} =
        attrs
        |> Enum.into(@valid_attrs)
        |> InvestsAllows.create_invest_allow()

      invest_allow
    end

    test "list_invests_allows/0 returns all invests_allows" do
      invest_allow = invest_allow_fixture()
      list_invest_allow = InvestsAllows.list_invests_allows()

      assert list_invest_allow == [invest_allow]
    end

    test "get_invest_allow!/1 returns the invest_allow with given id" do
      invest_allow = invest_allow_fixture()
      get_invests_allows = InvestsAllows.get_invest_allow!(invest_allow.id)

      assert get_invests_allows == invest_allow
    end

    test "create_invest_allow/1 with valid data creates a invest_allow" do
      assert {:ok, %InvestAllow{} = invest_allow} = InvestsAllows.create_invest_allow(@valid_attrs)
      assert invest_allow.description == "some description"
      assert invest_allow.invest == 21
      assert invest_allow.name == "some name"
    end

    test "create_invest_allow/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = InvestsAllows.create_invest_allow(@invalid_attrs)
    end

    test "update_invest_allow/2 with valid data updates the invest_allow" do
      init_invest_allow = invest_allow_fixture()
      assert {:ok, invest_allow} = InvestsAllows.update_invest_allow(init_invest_allow, @update_attrs)
      assert %InvestAllow{} = invest_allow
      assert invest_allow.description == "some updated description"
      assert invest_allow.invest == 43
      assert invest_allow.name == "some updated name"
    end

    test "update_invest_allow/2 with invalid data returns error changeset" do
      invest_allow = invest_allow_fixture()
      assert {:error, %Ecto.Changeset{}} = InvestsAllows.update_invest_allow(invest_allow, @invalid_attrs)

      update_invest_allow = InvestsAllows.get_invest_allow!(invest_allow.id)

      assert invest_allow == update_invest_allow
    end

    test "delete_invest_allow/1 deletes the invest_allow" do
      invest_allow = invest_allow_fixture()
      assert {:ok, %InvestAllow{}} = InvestsAllows.delete_invest_allow(invest_allow)
      assert_raise Ecto.NoResultsError, fn -> InvestsAllows.get_invest_allow!(invest_allow.id) end
    end

    test "change_invest_allow/1 returns a invest_allow changeset" do
      invest_allow = invest_allow_fixture()
      assert %Ecto.Changeset{} = InvestsAllows.change_invest_allow(invest_allow)
    end
  end
end
