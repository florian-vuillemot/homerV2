defmodule Homer.StepsTest do
  use Homer.DataCase

  alias Homer.Steps

  describe "steps" do
    alias Homer.Steps.Step

    @valid_attrs %{create_at: "2010-04-17 14:00:00.000000Z"}
    @update_attrs %{create_at: "2011-05-18 15:01:01.000000Z"}
    @invalid_attrs %{create_at: nil}

    def step_fixture(attrs \\ %{}) do
      {:ok, step} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Steps.create_step()

      step
    end

    test "list_steps/0 returns all steps" do
      step = step_fixture()
      assert Steps.list_steps() == [step]
    end

    test "get_step!/1 returns the step with given id" do
      step = step_fixture()
      assert Steps.get_step!(step.id) == step
    end

    test "create_step/1 with valid data creates a step" do
      assert {:ok, %Step{} = step} = Steps.create_step(@valid_attrs)
      assert step.create_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
    end

    test "create_step/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Steps.create_step(@invalid_attrs)
    end

    test "update_step/2 with valid data updates the step" do
      step = step_fixture()
      assert {:ok, step} = Steps.update_step(step, @update_attrs)
      assert %Step{} = step
      assert step.create_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
    end

    test "update_step/2 with invalid data returns error changeset" do
      step = step_fixture()
      assert {:error, %Ecto.Changeset{}} = Steps.update_step(step, @invalid_attrs)
      assert step == Steps.get_step!(step.id)
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
  end
end
