defmodule Homer.MonetizationsTest do
  use Homer.DataCase

  alias Homer.Monetizations

  describe "fundings" do
    alias Homer.Monetizations.Funding

    @valid_attrs %{description: "some description", name: "some name", unit: "some unit", days: 10, validate: 80}
    @update_attrs %{description: "some updated description", name: "some updated name", unit: "some updated unit", days: 15, validate: 85}
    @invalid_attrs %{description: nil, name: nil, unit: nil, days: nil, validate: nil}
    @invalid_attrs_create [%{description: nil, name: "name", unit: "unit", days: 10, validate: 80},
      %{description: "description", name: nil, unit: "unit", days: 10, validate: 80},
      %{description: "description", name: "name", unit: nil, days: 10, validate: 80},
      %{description: "description", name: "name", unit: "unit", days: nil, validate: 80},
      %{description: "description", name: "name", unit: "unit", days: 10, validate: nil},
    ]

    def funding_fixture(attrs \\ %{}) do
      {:ok, funding} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Monetizations.create_funding()

      funding
    end

    test "list_fundings/0 returns all fundings" do
      funding = funding_fixture()
      funding = %{funding | create: "#{Ecto.DateTime.to_iso8601(Ecto.DateTime.utc)}.000000Z"}

      list_fundings = Monetizations.list_fundings()
      list_fundings = Enum.map(
        list_fundings,
        fn x -> %{x | create: DateTime.to_iso8601(x.create)} end
      )

      assert list_fundings == [funding]
    end

    test "get_funding!/1 returns the funding with given id" do
      funding = funding_fixture()
      get_funding = Monetizations.get_funding!(funding.id)
      get_funding = %{get_funding | create: DateTime.to_iso8601(get_funding.create)}
      funding = %{funding | create: "#{Ecto.DateTime.to_iso8601(funding.create)}.000000Z"}
      assert get_funding == funding
    end

    test "create_funding/1 with valid data creates a funding" do
      assert {:ok, %Funding{} = funding} = Monetizations.create_funding(@valid_attrs)
      assert funding.create == Ecto.DateTime.utc
      assert funding.description == "some description"
      assert funding.name == "some name"
      assert funding.unit == "some unit"
      assert funding.valid == false
      assert funding.days == 10
      assert funding.validate == 80
      assert funding.projects == []
      assert funding.step_templates == []
    end

    test "create_funding/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Monetizations.create_funding(@invalid_attrs)
      Enum.map(@invalid_attrs_create,
        fn attrs -> assert {:error, %Ecto.Changeset{}} = Monetizations.create_funding(attrs) end
      )
    end

    test "update_funding/2 with valid data updates the funding" do
      init_funding = funding_fixture()
      assert {:ok, funding} = Monetizations.update_funding(init_funding, @update_attrs)
      assert %Funding{} = funding
      assert funding.create == init_funding.create
      assert funding.description == "some updated description"
      assert funding.name == "some updated name"
      assert funding.unit == "some updated unit"
      assert funding.valid == false
      assert funding.days == 15
      assert funding.validate == 85
      assert funding.projects == []
      assert funding.step_templates == []
    end

    test "update_funding/2 with invalid data returns error changeset" do
      funding = funding_fixture()
      assert {:error, %Ecto.Changeset{}} = Monetizations.update_funding(funding, @invalid_attrs)

      get_funding = Monetizations.get_funding!(funding.id)
      get_funding = %{get_funding | create: DateTime.to_iso8601(get_funding.create)}
      funding = %{funding | create: "#{Ecto.DateTime.to_iso8601(funding.create)}.000000Z"}
      assert funding == get_funding
    end

    test "delete_funding/1 deletes the funding" do
      funding = funding_fixture()
      assert {:ok, %Funding{}} = Monetizations.delete_funding(funding)
      assert_raise Ecto.NoResultsError, fn -> Monetizations.get_funding!(funding.id) end
    end

    test "change_funding/1 returns a funding changeset" do
      funding = funding_fixture()
      assert %Ecto.Changeset{} = Monetizations.change_funding(funding)
    end
  end
end
