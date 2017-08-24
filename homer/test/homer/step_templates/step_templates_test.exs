defmodule Homer.StepTemplatesTest do
  use Homer.DataCase

  alias Homer.StepTemplates

  describe "step_templates" do
    alias Homer.StepTemplates.StepTemplate

    @valid_attrs %{description: "some description", name: "some name", rank: 42}
    @update_attrs %{description: "some updated description", name: "some updated name", rank: 43}
    @invalid_attrs %{description: nil, name: nil, rank: nil}

    def step_template_fixture(attrs \\ %{}) do
      {:ok, step_template} =
        attrs
        |> Enum.into(@valid_attrs)
        |> StepTemplates.create_step_template()

      step_template
    end

    test "list_step_templates/0 returns all step_templates" do
      step_template = step_template_fixture()
      assert StepTemplates.list_step_templates() == [step_template]
    end

    test "get_step_template!/1 returns the step_template with given id" do
      step_template = step_template_fixture()
      assert StepTemplates.get_step_template!(step_template.id) == step_template
    end

    test "create_step_template/1 with valid data creates a step_template" do
      assert {:ok, %StepTemplate{} = step_template} = StepTemplates.create_step_template(@valid_attrs)
      assert step_template.description == "some description"
      assert step_template.name == "some name"
      assert step_template.rank == 42
    end

    test "create_step_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StepTemplates.create_step_template(@invalid_attrs)
    end

    test "update_step_template/2 with valid data updates the step_template" do
      step_template = step_template_fixture()
      assert {:ok, step_template} = StepTemplates.update_step_template(step_template, @update_attrs)
      assert %StepTemplate{} = step_template
      assert step_template.description == "some updated description"
      assert step_template.name == "some updated name"
      assert step_template.rank == 43
    end

    test "update_step_template/2 with invalid data returns error changeset" do
      step_template = step_template_fixture()
      assert {:error, %Ecto.Changeset{}} = StepTemplates.update_step_template(step_template, @invalid_attrs)
      assert step_template == StepTemplates.get_step_template!(step_template.id)
    end

    test "delete_step_template/1 deletes the step_template" do
      step_template = step_template_fixture()
      assert {:ok, %StepTemplate{}} = StepTemplates.delete_step_template(step_template)
      assert_raise Ecto.NoResultsError, fn -> StepTemplates.get_step_template!(step_template.id) end
    end

    test "change_step_template/1 returns a step_template changeset" do
      step_template = step_template_fixture()
      assert %Ecto.Changeset{} = StepTemplates.change_step_template(step_template)
    end
  end
end
