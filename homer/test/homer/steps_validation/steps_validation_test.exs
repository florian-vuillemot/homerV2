defmodule Homer.StepsValidationTest do
  use Homer.DataCase

  alias Homer.StepsValidation

  describe "steps_validation" do
    alias Homer.StepsValidation.StepValidation

    @valid_attrs %{comment: "some comment", valid: 42}
    #@update_attrs %{comment: "some updated comment", valid: 43}
    @invalid_attrs %{comment: nil, valid: nil}

    def step_validation_fixture(attrs \\ %{}) do
      {:ok, step_validation} =
        attrs
        |> Enum.into(valid_attrs(@valid_attrs))
        |> StepsValidation.create_step_validation()

      step_validation
    end

    def fixture(attrs \\ %{}) do
      attrs
      |> Enum.into(valid_attrs(@valid_attrs))
    end

    test "list_steps_validation/0 returns all steps_validation" do
      step_validation = step_validation_fixture()
      assert StepsValidation.list_steps_validation() == [step_validation]
    end

    test "get_step_validation!/1 returns the step_validation with given id" do
      step_validation = step_validation_fixture()
      assert StepsValidation.get_step_validation!(step_validation.id) == step_validation
    end

    test "create_step_validation/1 with valid data creates a step_validation" do
      step_validation = valid_attrs(@valid_attrs)
      assert {:ok, %StepValidation{} = step_validation} = StepsValidation.create_step_validation(step_validation)
      assert step_validation.comment == "some comment"
      assert step_validation.valid == 42
    end

    test "create_step_validation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StepsValidation.create_step_validation(@invalid_attrs)
    end
'''
    test "update_step_validation/2 with valid data updates the step_validation" do
      step_validation = step_validation_fixture()
      assert {:ok, step_validation} = StepsValidation.update_step_validation(step_validation, @update_attrs)
      assert %StepValidation{} = step_validation
      assert step_validation.comment == "some updated comment"
      assert step_validation.valid == 43
    end

    test "update_step_validation/2 with invalid data returns error changeset" do
      step_validation = step_validation_fixture()
      assert {:error, %Ecto.Changeset{}} = StepsValidation.update_step_validation(step_validation, @invalid_attrs)
      assert step_validation == StepsValidation.get_step_validation!(step_validation.id)
    end

    test "delete_step_validation/1 deletes the step_validation" do
      step_validation = step_validation_fixture()
      assert {:ok, %StepValidation{}} = StepsValidation.delete_step_validation(step_validation)
      assert_raise Ecto.NoResultsError, fn -> StepsValidation.get_step_validation!(step_validation.id) end
    end
'''
    test "change_step_validation/1 returns a step_validation changeset" do
      step_validation = step_validation_fixture()
      assert %Ecto.Changeset{} = StepsValidation.change_step_validation(step_validation)
    end
  end


  defp valid_attrs(attrs) do
    investor = Homer.InvestsTest.investor_fixture
    step = Homer.StepsTest.step_fixture

    attrs
    |> Map.put(:investor_id, investor.id)
    |> Map.put(:step_id, step.id)
  end
end
