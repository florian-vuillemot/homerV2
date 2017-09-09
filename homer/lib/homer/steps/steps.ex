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
    |> preload
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
    |> preload
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
    step =
      case Map.has_key?(attrs, :step_template) do
        true -> %Step{create_at: Ecto.DateTime.utc, step_template: Map.get(attrs, :step_template)}
        _    -> %Step{create_at: Ecto.DateTime.utc}
      end
      |> Step.changeset(attrs)
      |> Repo.insert()

    case step do
      {:ok, instance} ->
        {:ok, preload(instance)}
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
    initial_step = get_step!(step.id)

    # Not allow change user and project references after init.
    attrs = case Homer.Utilities.Constructor.same_fk(initial_step, attrs, [:project_id, :step_template_id])  do
      true ->
        attrs
      _ ->
        %{step_template_id: nil}
    end

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

  defp preload(step) do
    step
    |> Repo.preload(:project)
    |> Repo.preload(:steps_validation)
    |> Repo.preload(:step_template)
  end
end
