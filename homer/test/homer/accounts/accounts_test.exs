defmodule Homer.AccountsTest do
  use Homer.DataCase

  alias Homer.Accounts

  describe "users" do
    alias Homer.Accounts.User

    @valid_attrs %{email: "some email", password: "some password"}
    @update_attrs %{email: "some updated email", password: "some updated password"}
    @invalid_attrs %{email: nil, password: nil}

    def user_fixture(attrs \\ %{}, new_name \\ false) do
      attrs = case new_name do
        true -> Map.put(attrs, :email, "#{Enum.random(0..4242)}")
        _ -> attrs
      end

      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.password == "some password"
      assert user.admin == 0
      assert user.funders == []
      assert user.investor_on == []
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.password == "some updated password"
      assert user.admin == 0
      assert user.funders == []
      assert user.investor_on == []
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "find_and_confirm_password/2 return user exist" do
      initial_user = user_fixture()
      assert {:ok, user} = Accounts.find_and_confirm_password(initial_user.email, initial_user.password)
      assert initial_user == user
    end

    test "find_and_confirm_password/2 user exist but bad password" do
      user = user_fixture()
      assert {:error, :unauthorized} = Accounts.find_and_confirm_password(user.email, "bad pass #{user.password}")
    end

    test "find_and_confirm_password/2 user not exist" do
      user = user_fixture()
      assert {:error, :unauthorized} = Accounts.find_and_confirm_password("not exist #{user.email}", user.password)
    end

    test "find_and_confirm_password/2 user not exist and bad pass" do
      user = user_fixture()
      assert {:error, :unauthorized} = Accounts.find_and_confirm_password("not exist #{user.email}",  "bad pass #{user.password}")
    end
  end
end
