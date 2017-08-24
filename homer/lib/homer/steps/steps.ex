defmodule Homer.Steps do
  @moduledoc """
  The Steps context.
  """

  import Ecto.Query, warn: false
  alias Homer.Repo

  alias Homer.Steps.Step

  @doc """
  Returns the list of steps.

  ## Examples

      iex> list_steps()
      [%Step{}, ...]

  """
  def list_steps do
    Step
    |> Repo.all
    |> Repo.preload(:steps_validation)
  end

  @doc """
  Gets a single step.

  Raises `Ecto.NoResultsError` if the Step does not exist.

  ## Examples

      iex> get_step!(123)
      %Step{}

      iex> get_step!(456)
      ** (Ecto.NoResultsError)

  """
  def get_step!(id) do
    Step
    |> Repo.get!(id)
    |> Repo.preload(:steps_validation)
  end

  @doc """
  Creates a step.

  ## Examples

      iex> create_step(%{field: value})
      {:ok, %Step{}}

      iex> create_step(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_step(attrs \\ %{}) do
    step = %Step{create_at: Ecto.DateTime.utc}
    |> Step.changeset(attrs)
    |> Repo.insert()

    case step do
      {:ok, instance} ->
        instance = %{instance | steps_validation: []}
        {:ok, instance}
      _ -> step
    end
  end

  @doc """
  Updates a step.

  ## Examples

      iex> update_step(step, %{field: new_value})
      {:ok, %Step{}}

      iex> update_step(step, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_step(%Step{} = step, attrs) do
    step
    |> Step.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Step.

  ## Examples

      iex> delete_step(step)
      {:ok, %Step{}}

      iex> delete_step(step)
      {:error, %Ecto.Changeset{}}

  """
  def delete_step(%Step{} = step) do
    Repo.delete(step)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking step changes.

  ## Examples

      iex> change_step(step)
      %Ecto.Changeset{source: %Step{}}

  """
  def change_step(%Step{} = step) do
    Step.changeset(step, %{})
  end
end
