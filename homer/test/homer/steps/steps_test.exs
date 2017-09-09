defmodule Homer.StepsTest do
  use Homer.DataCase

  alias Homer.Steps

  describe "steps" do
    alias Homer.Steps.Step

    @valid_attrs %{name: "some name", description: "some description"}
    @update_attrs %{name: "some new name", description: "some new description"}
    #@invalid_attrs %{}

    def step_fixture(attrs \\ %{}) do
      {:ok, step} =
        attrs
        |> Enum.into(get_valid_attrs())
        |> Steps.create_step()

      step
    end

    test "list_steps/0 returns all steps" do
      step = step_fixture()
      step = %{step | create_at: "#{Ecto.DateTime.to_iso8601(Ecto.DateTime.utc)}.000000Z"}

      step_projects = Steps.list_steps()
      step_projects = Enum.map(
        step_projects,
        fn x -> %{x | create_at: DateTime.to_iso8601(x.create_at)} end
      )
      assert step_projects == [step]
    end

    test "get_step!/1 returns the step with given id" do
      step = step_fixture()
      step = %{step | create_at: "#{Ecto.DateTime.to_iso8601(Ecto.DateTime.utc)}.000000Z"}

      get_step = Steps.get_step!(step.id)
      get_step = %{get_step | create_at: DateTime.to_iso8601(get_step.create_at)}

      assert get_step == step
    end

    test "create_step/1 with valid data creates a step" do
      assert {:ok, %Step{} = step} = Steps.create_step(get_valid_attrs(@valid_attrs))
      assert Ecto.DateTime.to_iso8601(step.create_at) == Ecto.DateTime.to_iso8601(Ecto.DateTime.utc)
    end

    #test "create_step/1 with invalid data returns error changeset" do
    #  assert {:error, %Ecto.Changeset{}} = Steps.create_step(@invalid_attrs)
    #end

    test "update_step/2 with valid data updates the step" do
      step = step_fixture()
      attrs = Map.put(@update_attrs, :step_template_id, step.step_template_id)
      assert {:ok, step} = Steps.update_step(step, attrs)
      assert %Step{} = step
      assert Ecto.DateTime.to_iso8601(step.create_at) == Ecto.DateTime.to_iso8601(Ecto.DateTime.utc)
    end

    test "update_step/2 with invalid data returns error changeset" do
      #init_step = step_fixture()
      #assert {:error, %Ecto.Changeset{}} = Steps.update_step(init_step, @invalid_attrs)

      #update_step = Builders.get_project!(init_step.id)
      #update_step = %{update_step | create_at: DateTime.to_iso8601(update_step.create_at)}
      #step = %{init_step | create_at: "#{Ecto.DateTime.to_iso8601(init_step.create_at)}.000000Z"}
      #assert step == update_step
    end

    test "delete_step/1 deletes the step" do
      step = step_fixture()
      assert {:ok, %Step{}} = Steps.delete_step(step)
      assert_raise Ecto.NoResultsError, fn -> Steps.get_step!(step.id) end
    end

    test "change_step/1 returns a step changeset" do
      step = step_fixture()
      assert %Ecto.Changeset{} = Steps.change_step(step)
    end

    def get_valid_attrs(attrs \\ @valid_attrs, step \\ nil) do
      case nil !== step do
        true ->
          Enum.into(attrs, %{step_template_id: step.step_template_id})
        _ ->
          step_template = Homer.StepTemplatesTest.step_template_fixture()

          Enum.into(attrs, %{step_template_id: step_template.id})
      end
    end
  end
end
