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
    funding_id = case Map.has_key?(attrs, :funding_id) do
      true -> Map.get(attrs, :funding_id)
      _ -> Map.get(attrs, "funding_id")
    end

    steps = create_steps(attrs, funding_id)

    project = case steps do
      nil -> build_project(%{})
      _   ->
        {_, attrs} = Map.pop(attrs, :steps)
        build_project(attrs)
    end

    case project do
      {:ok, instance_project} -> Enum.map(steps,
          fn step ->
            {:ok, step} = step
            step = Map.put(step, :project_id, instance_project.id)
            Homer.Steps.update_step(step, %{})
          end
        )
        {:ok, preload_project(instance_project)}
      _ ->
        if steps != nil do
          delete_steps(steps)
        end
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

    # Not allow change funding references after init.
    attrs = case Homer.Utilities.Constructor.same_fk(init_project, attrs, [:funding_id]) do
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

  def invest(%Project{} = project) do
    actual_invest = case length(project.investors) do
      0 -> 0
      1 -> 1
      _ -> Enum.reduce(
              project.investors, 0,
              fn (investor, acc) ->
                invest_allow = Homer.InvestsAllows.get_invest_allow!(investor.invest_allow_id)
                acc + invest_allow.invest
              end
           )
    end

    {actual_invest, project.to_raise}
  end

  defp preload_project(project) do
    project
    |> Repo.preload(:steps)
    |> Repo.preload(:investors)
    |> Repo.preload(:funders)
    |> Repo.preload(:funding)
  end

  defp create_steps(_, nil), do: nil
  defp create_steps(attrs, funding_id) do
    attrs_step = case Map.has_key?(attrs, "steps") do
      true -> Map.get(attrs, "steps")
      _ -> Map.get(attrs, :steps)
    end

    case attrs_step do
      nil -> nil
      _   ->
        case check_same_funding_id(attrs_step, funding_id) and check_same_number_of_steps(attrs_step, funding_id) do
          true ->
            steps = Enum.map(attrs_step, fn step -> Homer.Steps.create_step(step) end)

            case Enum.any?(steps, fn x -> Homer.Utilities.Constructor.error_on_create(x) end) do
              false ->  steps
              _     ->  delete_steps(steps)
                        nil
            end

          _ -> nil
        end
    end
  end

  defp build_project(attrs) do
    %Project{create_at: Ecto.DateTime.utc, status: status_projects(:create)}
    |> Project.changeset(attrs)
    |> Repo.insert
  end

  defp delete_steps(steps) do
    Enum.map(steps, fn {_, step} ->
      Homer.Steps.delete_step(step) end)
  end

  defp check_same_funding_id(attrs_steps, funding_id) do
    steps = Enum.map(attrs_steps,
      fn step ->
        funding = case Map.has_key?(step, "funding_id") do
          true -> Map.get(step, "funding_id")
          _ -> Map.get(step, :funding_id)
        end
        funding_id != funding
      end
    )

    Enum.any?(steps)
  end

  defp check_same_number_of_steps(attrs_step, funding_id) do
    query = from step in "step_templates",
                 where: step.funding_id == ^funding_id,
                 select: count(step.id)

    length(attrs_step) === List.first(Repo.all(query))
  end
end
