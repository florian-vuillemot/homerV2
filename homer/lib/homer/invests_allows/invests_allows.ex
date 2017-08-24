defmodule Homer.InvestsAllows do
  @moduledoc """
  The InvestsAllows context.
  """

  import Ecto.Query, warn: false
  alias Homer.Repo

  alias Homer.InvestsAllows.InvestAllow

  @doc """
  Returns the list of invests_allows.

  ## Examples

      iex> list_invests_allows()
      [%InvestAllow{}, ...]

  """
  def list_invests_allows do
    InvestAllow
    |> Repo.all
    |> Repo.preload(:investors)
  end

  @doc """
  Gets a single invest_allow.

  Raises `Ecto.NoResultsError` if the Invest allow does not exist.

  ## Examples

      iex> get_invest_allow!(123)
      %InvestAllow{}

      iex> get_invest_allow!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invest_allow!(id) do
    InvestAllow
    |> Repo.get!(id)
    |> Repo.preload(:investors)
  end

  @doc """
  Creates a invest_allow.

  ## Examples

      iex> create_invest_allow(%{field: value})
      {:ok, %InvestAllow{}}

      iex> create_invest_allow(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invest_allow(attrs \\ %{}) do
    invest = %InvestAllow{:create_at => Ecto.DateTime.utc}
    |> InvestAllow.changeset(attrs)
    |> Repo.insert()


    case invest do
      {:ok, instance} ->
        instance = %{instance | investors: []}
        {:ok, instance}
      _ -> invest
    end
  end

  @doc """
  Updates a invest_allow.

  ## Examples

      iex> update_invest_allow(invest_allow, %{field: new_value})
      {:ok, %InvestAllow{}}

      iex> update_invest_allow(invest_allow, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invest_allow(%InvestAllow{} = invest_allow, attrs) do
    invest_allow
    |> InvestAllow.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a InvestAllow.

  ## Examples

      iex> delete_invest_allow(invest_allow)
      {:ok, %InvestAllow{}}

      iex> delete_invest_allow(invest_allow)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invest_allow(%InvestAllow{} = invest_allow) do
    Repo.delete(invest_allow)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invest_allow changes.

  ## Examples

      iex> change_invest_allow(invest_allow)
      %Ecto.Changeset{source: %InvestAllow{}}

  """
  def change_invest_allow(%InvestAllow{} = invest_allow) do
    InvestAllow.changeset(invest_allow, %{})
  end
end
