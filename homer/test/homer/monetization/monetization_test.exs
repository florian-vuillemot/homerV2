defmodule Homer.MonetizationTest do
  use Homer.DataCase

  alias Homer.Monetization

  describe "fundings" do
    alias Homer.Monetization.Funding

    @valid_attrs %{description: "some description", name: "some name", unit: "some unit"}
    @update_attrs %{description: "some updated description", name: "some updated name", unit: "some updated unit"}
    @invalid_attrs %{description: nil, name: nil, unit: nil}
    @invalid_attrs_create [%{description: nil, name: "name", unit: "unit"}, %{description: "description", name: nil, unit: "unit"}, %{description: "description", name: "name", unit: nil}]

    def funding_fixture(attrs \\ %{}) do
      {:ok, funding} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Monetization.create_funding()

      funding
    end

    test "list_fundings/0 returns all fundings" do
      funding = funding_fixture()
      assert Monetization.list_fundings() == [funding]
    end

    test "get_funding!/1 returns the funding with given id" do
      funding = funding_fixture()
      assert Monetization.get_funding!(funding.id) == funding
    end

    test "create_funding/1 with valid data creates a funding" do
      assert {:ok, %Funding{} = funding} = Monetization.create_funding(@valid_attrs)
      assert funding.create == nil
      assert funding.description == "some description"
      assert funding.name == "some name"
      assert funding.unit == "some unit"
      assert funding.valid == false
    end

    test "create_funding/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Monetization.create_funding(@invalid_attrs)
      Enum.map(@invalid_attrs_create,
        fn attrs -> assert {:error, %Ecto.Changeset{}} = Monetization.create_funding(attrs) end
      )
    end

    test "update_funding/2 with valid data updates the funding" do
      init_funding = funding_fixture()
      assert {:ok, funding} = Monetization.update_funding(init_funding, @update_attrs)
      assert %Funding{} = funding
      assert funding.create == init_funding.create
      assert funding.description == "some updated description"
      assert funding.name == "some updated name"
      assert funding.unit == "some updated unit"
      assert funding.valid == false
    end

    test "update_funding/2 with invalid data returns error changeset" do
      funding = funding_fixture()
      assert {:error, %Ecto.Changeset{}} = Monetization.update_funding(funding, @invalid_attrs)
      assert funding == Monetization.get_funding!(funding.id)
    end

    test "delete_funding/1 deletes the funding" do
      funding = funding_fixture()
      assert {:ok, %Funding{}} = Monetization.delete_funding(funding)
      assert_raise Ecto.NoResultsError, fn -> Monetization.get_funding!(funding.id) end
    end

    test "change_funding/1 returns a funding changeset" do
      funding = funding_fixture()
      assert %Ecto.Changeset{} = Monetization.change_funding(funding)
    end
  end
end
