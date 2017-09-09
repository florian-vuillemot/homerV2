defmodule Homer.BuildersTest do
  use Homer.DataCase

  alias Homer.Builders

  describe "projects" do
    alias Homer.Builders.Project

    @valid_attrs %{name: "some name", description: "some description", to_raise: 42}
    @update_attrs %{name: "some update name", description: "some updated description", to_raise: 43, github: "some github"}
    @invalid_attrs %{name: nil, description: nil, to_raise: nil}

    def project_fixture(attrs \\ %{}, new_name \\ false) do
      attrs = case new_name do
        true -> Map.put(attrs, :name, "#{Enum.random(0..4242)}")
        _ -> attrs
      end

      {:ok, project} =
        Enum.into(attrs, get_valid_attrs())
        |> Builders.create_project()

      project
    end

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      project = %{project | create_at: "#{Ecto.DateTime.to_iso8601(Ecto.DateTime.utc)}.000000Z", status: Homer.Builders.status_projects(:create)}

      list_projects = Builders.list_projects()
      list_projects = Enum.map(
        list_projects,
        fn x -> %{x | create_at: DateTime.to_iso8601(x.create_at)} end
      )

      assert list_projects == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      get_project = Builders.get_project!(project.id)
      get_project = %{get_project | create_at: DateTime.to_iso8601(get_project.create_at)}
      project = %{project | create_at: "#{Ecto.DateTime.to_iso8601(project.create_at)}.000000Z"}
      assert get_project == project
    end

    test "create_project/1 with valid data creates a project" do
      assert {:ok, %Project{} = project} = Builders.create_project(get_valid_attrs(@valid_attrs))
      assert project.name == "some name"
      assert Ecto.DateTime.to_iso8601(project.create_at) == Ecto.DateTime.to_iso8601(Ecto.DateTime.utc)
      assert project.description == "some description"
      assert project.status == Homer.Builders.status_projects(:create)
      assert project.to_raise == 42
      assert project.steps == []
      assert project.github == nil
      assert project.investors == []
      assert project.funders == []
      assert project.funding == nil
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Builders.create_project(get_valid_attrs(@invalid_attrs))
    end

    test "create_project/1 with invalid funding ref in step returns error changeset" do
      attrs = get_valid_attrs(@valid_attrs)
      attrs = Map.put(attrs, :funding_id, attrs.funding_id - 1)
      assert {:error, %Ecto.Changeset{}} = Builders.create_project(attrs)
    end

    test "update_project/2 with valid data updates the project" do
      init_project = project_fixture()
      project_attr = %{get_valid_attrs(@update_attrs) | funding_id: init_project.funding_id}
      assert {:ok, project} = Builders.update_project(init_project, project_attr)
      assert %Project{} = project
      assert project.name == "some update name"
      assert project.create_at == init_project.create_at
      assert project.description == "some updated description"
      assert project.status == init_project.status
      assert project.to_raise == 43
      assert project.steps == []
      assert project.github == "some github"
      assert project.investors == []
      assert project.funders == []
      assert project.funding == nil
    end

    test "update_project/2 with invalid data returns error changeset" do
      init_project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Builders.update_project(init_project, get_valid_attrs(@invalid_attrs))
      update_project = Builders.get_project!(init_project.id)
      update_project = %{update_project | create_at: DateTime.to_iso8601(update_project.create_at)}
      project = %{init_project | create_at: "#{Ecto.DateTime.to_iso8601(init_project.create_at)}.000000Z", status: init_project.status}
      assert project == update_project
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

    test "create_project/2 with invalid fk" do
      assert {:error, %Ecto.Changeset{}} = Builders.create_project(@valid_attrs)
    end

    test "update_project/2 with invalid other fk" do
      init_project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Builders.update_project(init_project, get_valid_attrs(@valid_attrs))
      update_project = Builders.get_project!(init_project.id)
      update_project = %{update_project | create_at: DateTime.to_iso8601(update_project.create_at)}
      project = %{init_project | create_at: "#{Ecto.DateTime.to_iso8601(init_project.create_at)}.000000Z", status: init_project.status}
      assert project == update_project
    end

    defp get_valid_attrs(attrs \\ @valid_attrs) do
      funding = Homer.MonetizationsTest.funding_fixture

      steps = Enum.map(
        funding.step_templates,
        fn step_template -> %{step_template_id: step_template.id} end
      )

      attrs
      |> Map.put(:steps, steps)
      |> Map.put(:funding_id, funding.id)
    end
  end
end
