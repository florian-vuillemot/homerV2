defmodule Homer.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Homer.Repo

  alias Homer.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    User
    |> Repo.all
    |> preload
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> preload
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    user = %User{}
    |> User.changeset(attrs)
    |> Repo.insert()

    case user do
      {:ok, instance} ->
        {:ok, preload(instance)}
      _ -> user
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Return user if found.

  ## Examples

      iex> find_and_confirm_password("user_exist", "correct_password")
      {:ok, %User{}}

      iex> find_and_confirm_password("not_exist", "correct_password")
      {:error, :unauthorized}

      iex> find_and_confirm_password("user_exist", "bad_password")
      {:error, :unauthorized}

      iex> find_and_confirm_password("not_exist", "bad_password")
      {:error, :unauthorized}
  """
  def find_and_confirm_password(email, password) do
    query =
      from u in User,
           where: u.email == ^email and u.password == ^password

    case Repo.one(query) do
      %User{} = user -> {:ok, preload(user)}
      nil -> {:error, :unauthorized}
    end
  end

  @doc """
    Return true if user is a admin

    iex> is_admin(admin_user_id)
          true
    iex> is_admin(no_admin_user_id)
          false
"""
  def is_admin?(user_id) when is_integer(user_id) do
    case get_user!(user_id).admin do
      1 -> true
      _ -> false
    end
  end

  @doc """
    Make the user admin and save.

    iex> make_admin(user, %{field: new_value})
        {:ok, %User{}}

    iex> make_admin(%{user_id: bad_id})
        {:error, %Ecto.Changeset{}}
"""
  def make_admin(user_id) when is_integer(user_id) do
    user = get_user!(user_id)

    user
    |> User.make_admin()
    |> Repo.update()
  end

  #######################################################################################
  #######################################################################################
  #######################################################################################
  #######################################################################################
  #######################################################################################
  
  defp preload(user) do
    user
    |> Repo.preload(:investor_on)
    |> Repo.preload(:funders)
  end
end
