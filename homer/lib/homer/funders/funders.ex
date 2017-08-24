defmodule Homer.Funders do
  @moduledoc """
  The Funders context.
  """

  import Ecto.Query, warn: false
  alias Homer.Repo

  alias Homer.Funders.Funder

  @doc """
  Returns the list of funders.

  ## Examples

      iex> list_funders()
      [%Funder{}, ...]

  """
  def list_funders do
    Repo.all(Funder)
  end

  @doc """
  Gets a single funder.

  Raises `Ecto.NoResultsError` if the Funder does not exist.

  ## Examples

      iex> get_funder!(123)
      %Funder{}

      iex> get_funder!(456)
      ** (Ecto.NoResultsError)

  """
  def get_funder!(id), do: Repo.get!(Funder, id)

  @doc """
  Creates a funder.

  ## Examples

      iex> create_funder(%{field: value})
      {:ok, %Funder{}}

      iex> create_funder(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_funder(attrs \\ %{}) do
    %Funder{}
    |> Funder.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a funder.

  ## Examples

      iex> update_funder(funder, %{field: new_value})
      {:ok, %Funder{}}

      iex> update_funder(funder, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_funder(%Funder{} = funder, attrs) do
    funder
    |> Funder.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Funder.

  ## Examples

      iex> delete_funder(funder)
      {:ok, %Funder{}}

      iex> delete_funder(funder)
      {:error, %Ecto.Changeset{}}

  """
  def delete_funder(%Funder{} = funder) do
    Repo.delete(funder)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking funder changes.

  ## Examples

      iex> change_funder(funder)
      %Ecto.Changeset{source: %Funder{}}

  """
  def change_funder(%Funder{} = funder) do
    Funder.changeset(funder, %{})
  end
end
