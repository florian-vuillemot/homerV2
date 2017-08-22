defmodule Homer.Monetizations do
  @moduledoc """
  The Monetization context.
  """

  import Ecto.Query, warn: false
  alias Homer.Repo

  alias Homer.Monetizations.Funding

  @doc """
  Returns the list of fundings.

  ## Examples

      iex> list_fundings()
      [%Funding{}, ...]

  """
  def list_fundings do
    Repo.all(Funding)
  end

  @doc """
  Gets a single funding.

  Raises `Ecto.NoResultsError` if the Funding does not exist.

  ## Examples

      iex> get_funding!(123)
      %Funding{}

      iex> get_funding!(456)
      ** (Ecto.NoResultsError)

  """
  def get_funding!(id), do: Repo.get!(Funding, id)

  @doc """
  Creates a funding.
  Set default value for "create" field.

  ## Examples

      iex> create_funding(%{field: value})
      {:ok, %Funding{}}

      iex> create_funding(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_funding(attrs \\ %{}) do
    %Funding{}
    |> Funding.changeset(attrs)
    |> Map.put(:create, Ecto.DateTime.utc)
    |> Repo.insert()
  end

  @doc """
  Updates a funding.

  ## Examples

      iex> update_funding(funding, %{field: new_value})
      {:ok, %Funding{}}

      iex> update_funding(funding, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_funding(%Funding{} = funding, attrs) do
    funding
    |> Funding.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Funding.

  ## Examples

      iex> delete_funding(funding)
      {:ok, %Funding{}}

      iex> delete_funding(funding)
      {:error, %Ecto.Changeset{}}

  """
  def delete_funding(%Funding{} = funding) do
    Repo.delete(funding)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking funding changes.

  ## Examples

      iex> change_funding(funding)
      %Ecto.Changeset{source: %Funding{}}

  """
  def change_funding(%Funding{} = funding) do
    Funding.changeset(funding, %{})
  end
end
