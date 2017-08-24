defmodule Homer.StepTemplates do
  @moduledoc """
  The StepTemplates context.
  """

  import Ecto.Query, warn: false
  alias Homer.Repo

  alias Homer.StepTemplates.StepTemplate

  @doc """
  Returns the list of step_templates.

  ## Examples

      iex> list_step_templates()
      [%StepTemplate{}, ...]

  """
  def list_step_templates do
    StepTemplate
    |> Repo.all
    |> Repo.preload(:steps)
  end

  @doc """
  Gets a single step_template.

  Raises `Ecto.NoResultsError` if the Step template does not exist.

  ## Examples

      iex> get_step_template!(123)
      %StepTemplate{}

      iex> get_step_template!(456)
      ** (Ecto.NoResultsError)

  """
  def get_step_template!(id) do
    StepTemplate
    |> Repo.get!(id)
    |> Repo.preload(:steps)
  end

  @doc """
  Creates a step_template.

  ## Examples

      iex> create_step_template(%{field: value})
      {:ok, %StepTemplate{}}

      iex> create_step_template(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_step_template(attrs \\ %{}) do
    step_template = %StepTemplate{}
    |> StepTemplate.changeset(attrs)
    |> Repo.insert()

    case step_template do
      {:ok, instance} ->
        instance = %{instance | steps: []}
        {:ok, instance}
      _ -> step_template
    end
  end

  @doc """
  Updates a step_template.

  ## Examples

      iex> update_step_template(step_template, %{field: new_value})
      {:ok, %StepTemplate{}}

      iex> update_step_template(step_template, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_step_template(%StepTemplate{} = step_template, attrs) do
    step_template
    |> StepTemplate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a StepTemplate.

  ## Examples

      iex> delete_step_template(step_template)
      {:ok, %StepTemplate{}}

      iex> delete_step_template(step_template)
      {:error, %Ecto.Changeset{}}

  """
  def delete_step_template(%StepTemplate{} = step_template) do
    Repo.delete(step_template)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking step_template changes.

  ## Examples

      iex> change_step_template(step_template)
      %Ecto.Changeset{source: %StepTemplate{}}

  """
  def change_step_template(%StepTemplate{} = step_template) do
    StepTemplate.changeset(step_template, %{})
  end
end
