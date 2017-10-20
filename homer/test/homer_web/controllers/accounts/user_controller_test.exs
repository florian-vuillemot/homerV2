defmodule HomerWeb.Accounts.UserControllerTest do
  use HomerWeb.ConnCase

  alias Homer.Accounts
  alias Homer.Accounts.User

  @create_attrs %{email: "some email", password: "some password"}
  @update_attrs %{email: "some updated email", password: "some updated password"}
  @invalid_attrs [%{email: nil, password: nil}, %{email: nil, password: "password"}, %{email: "email", password: nil}, %{email: nil}, %{password: nil}]
  @miss_attrs [%{email: nil}, %{password: nil}, %{}]

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      conn = get conn, accounts_user_path(conn, :index)
      len_res = length(json_response(conn, 200)["users"])
      assert len_res == 1
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      new_conn = post conn, accounts_user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(new_conn, 201)["user"]

      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = get conn, accounts_user_path(conn, :show, id)
      assert json_response(new_conn, 200)["user"] == %{
        "id" => id,
        "email" => "some email",
        "admin" => 0,
        "investor_on" => [],
        "funders" => []}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      bad_attrs = @invalid_attrs ++ @miss_attrs
      Enum.map(bad_attrs,
        fn attrs ->
          new_conn = post conn, accounts_user_path(conn, :create), user: attrs
          assert json_response(new_conn, 422)["errors"] != %{}
        end
      )
    end

    test "no update admin", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      bad_attrs = @invalid_attrs ++ @miss_attrs
      Enum.map(bad_attrs,
        fn attrs ->
          new_conn = post conn, accounts_user_path(conn, :create), user: attrs
          assert json_response(new_conn, 422)["errors"] != %{}
        end
      )
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = put conn, accounts_user_path(conn, :update, user), user: @update_attrs
      assert %{"id" => ^id} = json_response(new_conn, 200)["user"]

      new_conn = get conn, accounts_user_path(conn, :show, id)
      assert json_response(new_conn, 200)["user"] == %{
        "id" => id,
        "email" => "some updated email",
        "admin" => 0,
        "investor_on" => [],
        "funders" => []}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      Enum.map(@invalid_attrs,
        fn attrs ->
          new_conn = put conn, accounts_user_path(conn, :update, user), user: attrs
          assert json_response(new_conn, 422)["errors"] != %{}
       end
      )
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn, true)
      new_conn = delete conn, accounts_user_path(conn, :delete, user)
      assert response(new_conn, 204)
      assert_error_sent 404, fn ->
        get conn, accounts_user_path(conn, :show, user)
      end
    end
  end

  describe "access not allow" do
    test "not allow list all user", %{conn: conn} do
      conn = get conn, accounts_user_path(conn, :index)
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow get a user", %{conn: conn} do
      %User{id: id} = fixture(:user)
      conn = get conn, accounts_user_path(conn, :show, id)
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow to update a user", %{conn: conn} do
      user = fixture(:user)
      conn = put conn, accounts_user_path(conn, :update, user), user: @update_attrs
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow to delete a user", %{conn: conn} do
      user = fixture(:user)
      conn = delete conn, accounts_user_path(conn, :delete, user)
      assert json_response(conn, 401)["message"] != %{}
    end

    test "cant delete a user", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      user = fixture(:user)
      new_conn = delete conn, accounts_user_path(conn, :delete, user)
      assert new_conn.status == 403
    end

    test "not allow to make admin", %{conn: conn} do
      new_conn = post conn, accounts_user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(new_conn, 201)["user"]

      post conn, accounts_user_path(conn, :make_admin), id: id
      assert false == Homer.Accounts.is_admin?(id)
    end
  end

  describe "admin test" do
    test "create admin", %{conn: conn} do
      admin_conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn, true)
      new_conn = post conn, accounts_user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(new_conn, 201)["user"]

      get admin_conn, accounts_user_path(admin_conn, :show, id)
      assert false == Homer.Accounts.is_admin?(id)

      post admin_conn, accounts_user_path(admin_conn, :make_admin), id: id
      assert true == Homer.Accounts.is_admin?(id)
    end

    test "cant create", %{conn: conn} do
      no_admin_conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)

      new_conn = post no_admin_conn, accounts_user_path(no_admin_conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(new_conn, 201)["user"]

      post no_admin_conn, accounts_user_path(no_admin_conn, :make_admin), id: id
      assert false == Homer.Accounts.is_admin?(id)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
