defmodule Homer.Invests do
  @moduledoc """
  The Invests context.
  """

  import Ecto.Query, warn: false
  alias Homer.Repo

  alias Homer.Invests.Investor

  @doc """
  Returns the list of investors.

  ## Examples

      iex> list_investors()
      [%Investor{}, ...]

  """
  def list_investors do
    Investor
    |> Repo.all
    |> preload_investor
  end

  @doc """
  Gets a single investor.

  Raises `Ecto.NoResultsError` if the Investor does not exist.

  ## Examples

      iex> get_investor!(123)
      %Investor{}

      iex> get_investor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_investor!(id) do
    Investor
    |> Repo.get!(id)
    |> preload_investor
  end

  @doc """
  Creates a investor.

  ## Examples

      iex> create_investor(%{field: value})
      {:ok, %Investor{}}

      iex> create_investor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_investor(attrs \\ %{}) do
    project_id = case Map.has_key?(attrs, :project_id) do
      true -> Map.get(attrs, :project_id)
      _ -> Map.get(attrs, "project_id")
    end
    invest_allow_id = case Map.has_key?(attrs, :invest_allow_id) do
      true -> Map.get(attrs, :invest_allow_id)
      _ -> Map.get(attrs, "invest_allow_id")
    end

    invest_allow = try do
      {actual_invest, to_raise} = Homer.Builders.get_project!(project_id) |> Homer.Builders.invest
      invest_allow = Homer.InvestsAllows.get_invest_allow! invest_allow_id
      actual_invest + invest_allow.invest <= to_raise
    rescue
      _ -> false
    end

    case invest_allow do
      true -> investor = %Investor{}
        |> Investor.changeset(attrs)
        |> Repo.insert()

        case investor do
          {:ok, instance} ->
            {:ok, preload_investor(instance)}
          _ -> investor
        end
      _ ->
        changeset = Investor.changeset(%Investor{}, %{})
        {:error, Ecto.Changeset.add_error(changeset, :error, "Ever invest")}
    end
  end

  @doc """
  Updates a investor.

  ## Examples

      iex> update_investor(investor, %{field: new_value})
      {:ok, %Investor{}}

      iex> update_investor(investor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_investor(%Investor{} = investor, attrs) do
    investor
    |> Investor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Investor.

  ## Examples

      iex> delete_investor(investor)
      {:ok, %Investor{}}

      iex> delete_investor(investor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_investor(%Investor{} = investor) do
    Repo.delete(investor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking investor changes.

  ## Examples

      iex> change_investor(investor)
      %Ecto.Changeset{source: %Investor{}}

  """
  def change_investor(%Investor{} = investor) do
    Investor.changeset(investor, %{})
  end

  defp preload_investor(investor) do
    investor
    |> Repo.preload(:steps_validation)
    |> Repo.preload(:user)
    |> Repo.preload(:invest_allow)
    |> Repo.preload(:project)
  end
end
