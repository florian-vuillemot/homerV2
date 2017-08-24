defmodule Homer.StepsValidation do
  @moduledoc """
  The StepsValidation context.
  """

  import Ecto.Query, warn: false
  alias Homer.Repo

  alias Homer.StepsValidation.StepValidation

  @doc """
  Returns the list of steps_validation.

  ## Examples

      iex> list_steps_validation()
      [%StepValidation{}, ...]

  """
  def list_steps_validation do
    Repo.all(StepValidation)
  end

  @doc """
  Gets a single step_validation.

  Raises `Ecto.NoResultsError` if the Step validation does not exist.

  ## Examples

      iex> get_step_validation!(123)
      %StepValidation{}

      iex> get_step_validation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_step_validation!(id), do: Repo.get!(StepValidation, id)

  @doc """
  Creates a step_validation.

  ## Examples

      iex> create_step_validation(%{field: value})
      {:ok, %StepValidation{}}

      iex> create_step_validation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_step_validation(attrs \\ %{}) do
    %StepValidation{}
    |> StepValidation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a step_validation.

  ## Examples

      iex> update_step_validation(step_validation, %{field: new_value})
      {:ok, %StepValidation{}}

      iex> update_step_validation(step_validation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_step_validation(%StepValidation{} = step_validation, attrs) do
    step_validation
    |> StepValidation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a StepValidation.

  ## Examples

      iex> delete_step_validation(step_validation)
      {:ok, %StepValidation{}}

      iex> delete_step_validation(step_validation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_step_validation(%StepValidation{} = step_validation) do
    Repo.delete(step_validation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking step_validation changes.

  ## Examples

      iex> change_step_validation(step_validation)
      %Ecto.Changeset{source: %StepValidation{}}

  """
  def change_step_validation(%StepValidation{} = step_validation) do
    StepValidation.changeset(step_validation, %{})
  end
end
