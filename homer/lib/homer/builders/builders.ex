defmodule Homer.Builders do
  @moduledoc """
  The Builders context.
  """

  import Ecto.Query, warn: false
  alias Homer.Repo

  alias Homer.Builders.Project

  @doc """
  Return string the status for project from atom.

  ## Examples
    iex> status_projects(:create)
    "To fund"

    iex> status_projects(:funding)
    "Funding"

    iex> status_projects(:in_progress)
    "In progress"

    iex> status_projects(:success)
    "Finish with success"

    iex> status_projects(:fail)
    "Finish in fail"

    iex> status_projects(:abandoned)
    "Abandoned"
  """
  def status_projects(status) do
    status_map = %{
      :create => "To fund",
      :funding => "Funding",
      :in_progress => "In progress",
      :success => "Finish with success",
      :fail => "Finish in fail",
      :abandoned => "Abandoned"
    }

    status_map[status]
  end

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    Project
    |> Repo.all
    |> preload_project
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id) do
    Project
    |> Repo.get!(id)
    |> preload_project
  end

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    project = %Project{create_at: Ecto.DateTime.utc, status: status_projects(:create)}
              |> Project.changeset(attrs)
              |> Repo.insert

    case project do
      {:ok, instance} ->
        instance = instance
                   |> preload_project
        {:ok, instance}
      _ ->
        project
    end
  end


  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    init_project = get_project!(project.id)

    attrs = case init_project.funding_id == Map.get(attrs, :funding_id) do
      true ->
        attrs
      _ ->
        %{funding_id: nil}
    end

    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{source: %Project{}}

  """
  def change_project(%Project{} = project) do
    Project.changeset(project, %{})
  end

  defp preload_project(project) do
    project
    |> Repo.preload(:steps)
    |> Repo.preload(:investors)
    |> Repo.preload(:funders)
    |> Repo.preload(:funding)
  end
end
