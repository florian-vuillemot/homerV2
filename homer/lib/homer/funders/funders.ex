defmodule Homer.Funders do
  @moduledoc """
  The Funders context.
  """

  import Ecto.Query, warn: false
  alias Homer.Repo

  alias Homer.Funders.Funder

  @doc """
  Return true if status funder exist.
  Only value of status validate by this function is allow in database.

  ## Examples

      iex> is_status_funder?("Creator")
      true

      iex> is_status_funder?("Worker")
      true

      iex> is_status_funder?("OHER")
      false

  """
  def is_status_funder?(status) do
    status_cast = %{
      "Creator" => 1,
      "Worker" => 1
    }

    Map.has_key?(status_cast, status)
  end

  @doc """
  Returns the list of funders.

  ## Examples

      iex> list_funders()
      [%Funder{}, ...]

  """
  def list_funders do
    Funder
    |> Repo.all
    |> Repo.preload(:project)
    |> Repo.preload(:user)
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
  def get_funder!(id) do
    Funder
    |> Repo.get!(id)
    |> Repo.preload(:project)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a funder.
  Check if status is allow before insert.

  ## Examples

      iex> create_funder(%{field: value})
      {:ok, %Funder{}}

      iex> create_funder(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_funder(attrs) do
    funder =
      case attrs do
        %{status: status}
          -> check_funder_status(attrs, status)
        %{"status" => status}
          -> check_funder_status(attrs, status)
        _
          -> check_funder_status(nil, nil)
      end

    case funder do
      {:ok, instance} ->
        instance = %{instance | user: nil, project: nil}
        {:ok, instance}
      _ -> funder
    end
  end


  @doc """
  Updates a funder.
  Check if status is allow before update.

  ## Examples

      iex> update_funder(funder, %{field: new_value})
      {:ok, %Funder{}}

      iex> update_funder(funder, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_funder(%Funder{} = funder, attrs) do
    case attrs do
      %{status: status}
        -> check_funder_status(attrs, status, funder)
      %{"status" => status}
        -> check_funder_status(attrs, status, funder)
      _
        -> check_funder_status(nil, nil, funder)
    end
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

##########################################################################
##########################################################################
##########################################################################
##########################################################################

  @doc false
  defp check_funder_status(attrs, status, funder \\ nil) do
    case is_status_funder?(status) do
      true -> insert_funder(attrs, funder)
      _    -> insert_funder(%{status: nil}, funder)
    end
  end

  @doc false
  defp insert_funder(attrs, funder) do
    case funder do
      nil
        -> %Funder{}
           |> Funder.changeset(attrs)
           |> Repo.insert()
      _
        -> funder
           |> Funder.changeset(attrs)
           |> Repo.update()
    end
  end
end
