defmodule Homer.BuildersTest do
  use Homer.DataCase

  alias Homer.Builders

  describe "projects" do
    alias Homer.Builders.Project

    @valid_attrs %{create_at: "2010-04-17 14:00:00.000000Z", description: "some description", status: 42, to_raise: 42}
    @update_attrs %{create_at: "2011-05-18 15:01:01.000000Z", description: "some updated description", status: 43, to_raise: 43}
    @invalid_attrs %{create_at: nil, description: nil, status: nil, to_raise: nil}

    def project_fixture(attrs \\ %{}) do
      {:ok, project} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Builders.create_project()

      project
    end

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Builders.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Builders.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      assert {:ok, %Project{} = project} = Builders.create_project(@valid_attrs)
      assert project.create_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert project.description == "some description"
      assert project.status == 42
      assert project.to_raise == 42
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Builders.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      assert {:ok, project} = Builders.update_project(project, @update_attrs)
      assert %Project{} = project
      assert project.create_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert project.description == "some updated description"
      assert project.status == 43
      assert project.to_raise == 43
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Builders.update_project(project, @invalid_attrs)
      assert project == Builders.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Builders.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Builders.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Builders.change_project(project)
    end
  end
end
