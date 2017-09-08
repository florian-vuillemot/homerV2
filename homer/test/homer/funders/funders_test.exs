defmodule Homer.FundersTest do
  use Homer.DataCase

  alias Homer.Funders

  describe "funders" do
    alias Homer.Funders.Funder

    @valid_attrs %{status: "Creator"}
    @update_attrs %{status: "Worker"}
    @invalid_attrs %{status: nil}

    @valid_status_funder ["Creator", "Worker"]
    @invalid_status_funder ["bad", nil]

    def funder_fixture(attrs \\ %{}) do
      {:ok, funder} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(get_valid_attrs())
        |> Funders.create_funder()

      funder
    end

    test "list_funders/0 returns all funders" do
      funder = funder_fixture()
      assert Funders.list_funders() == [funder]
    end

    test "get_funder!/1 returns the funder with given id" do
      funder = funder_fixture()
      assert Funders.get_funder!(funder.id) == funder
    end

    test "create_funder/1 with valid data creates a funder" do
      assert {:ok, %Funder{} = funder} = Funders.create_funder(get_valid_attrs())
      assert funder.status == "Creator"
      assert funder.user != nil
      assert funder.project != nil
    end

    test "create_funder/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Funders.create_funder(get_valid_attrs(@invalid_attrs))

      random_number =  :rand.uniform(100000)
      attrs = get_valid_attrs(@valid_attrs)

      bad_project = Map.put(attrs, :project_id, random_number)
      assert {:error, %Ecto.Changeset{}} = Funders.create_funder(bad_project)

      bad_user = Map.put(attrs, :user_id, random_number)
      assert {:error, %Ecto.Changeset{}} = Funders.create_funder(bad_user)
    end

    test "update_funder/2 with valid data updates the funder" do
      funder = funder_fixture()
      assert {:ok, funder} = Funders.update_funder(funder, @update_attrs)
      assert %Funder{} = funder
      assert funder.status == "Worker"
      assert funder.user != nil
      assert funder.project != nil
    end

    test "update_funder/2 with invalid data returns error changeset" do
      funder = funder_fixture()
      assert {:error, %Ecto.Changeset{}} = Funders.update_funder(funder, @invalid_attrs)
      assert funder == Funders.get_funder!(funder.id)

      other_funder = funder_fixture() # Other funder with other user and project
      funder_with_new_user = Map.put(@update_attrs, :user_id, Map.get(other_funder, :user_id))
      funder_with_new_project = Map.put(@update_attrs, :project_id, Map.get(other_funder, :project_id))

      assert {:error, %Ecto.Changeset{}} = Funders.update_funder(funder, funder_with_new_user)
      assert funder == Funders.get_funder!(funder.id)

      assert {:error, %Ecto.Changeset{}} = Funders.update_funder(funder, funder_with_new_project)
      assert funder == Funders.get_funder!(funder.id)
    end

    test "delete_funder/1 deletes the funder" do
      funder = funder_fixture()
      assert {:ok, %Funder{}} = Funders.delete_funder(funder)
      assert_raise Ecto.NoResultsError, fn -> Funders.get_funder!(funder.id) end
    end

    test "change_funder/1 returns a funder changeset" do
      funder = funder_fixture()
      assert %Ecto.Changeset{} = Funders.change_funder(funder)
    end

    test "is_status_funder?/1 with valid data" do
      Enum.map(
        @valid_status_funder,
        fn status -> assert true = Funders.is_status_funder?(status) end
      )
    end

    test "is_status_funder?/1 with invalid data" do
      Enum.map(
        @invalid_status_funder,
        fn status -> assert true != Funders.is_status_funder?(status) end
      )
    end

    defp get_valid_attrs(attrs \\ @valid_attrs) do
      user = Homer.AccountsTest.user_fixture(%{}, true)
      project = Homer.BuildersTest.project_fixture(%{}, true)

      attrs
      |> Map.put(:user_id, user.id)
      |> Map.put(:project_id, project.id)
    end
  end
end
