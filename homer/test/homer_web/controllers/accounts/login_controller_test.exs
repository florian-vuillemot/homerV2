defmodule HomerWeb.Accounts.LoginControllerTest do
  use HomerWeb.ConnCase

  describe "login" do
    test "not login", %{conn: conn} do
      conn = get conn, accounts_user_path(conn, :index)
      assert conn.status == 401
    end

    test "test login users", %{conn: conn} do
      user = HomerWeb.Accounts.UserControllerTest.fixture(:user)
      user_data = %{"email": user.email, "password": user.password}
      new_conn = HomerWeb.Accounts.UserAuth.login(conn, user_data)
      assert new_conn.assigns.jwt != ""
    end

    test "test logout", %{conn: conn} do
      user = HomerWeb.Accounts.UserControllerTest.fixture(:user)
      user_data = %{"email": user.email, "password": user.password}
      new_conn = HomerWeb.Accounts.UserAuth.login(conn, user_data)
      assigns_conn = Map.put(conn, :jwt, new_conn.assigns.jwt)
      conn = Map.put(conn, :assigns, assigns_conn)
      HomerWeb.Accounts.UserAuth.logout(conn, user_data)
      conn = get conn, accounts_user_path(conn, :index)
      assert conn.status == 401
    end

    test "test bad login", %{conn: conn} do
      user_data = %{"email": "", "password": ""}
      new_conn = HomerWeb.Accounts.UserAuth.login(conn, user_data)
      assert new_conn.assigns.message == "Could not login"
    end
  end

  @doc """
    Create a customer and log it.
    Take a conn parameter, fill and return it.
  """
  def auth_user(conn, create_admin \\ false, return_id \\ false) do
    user = case create_admin do
      false -> Homer.AccountsTest.user_fixture(%{password: "test_password"}, true)
      _ -> Homer.AccountsTest.create_admin(%{password: "test_password"}, true)
    end
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)

    new_conn = conn
               |> Plug.Conn.put_req_header("accept", "application/json")
               |> Plug.Conn.put_req_header("authorization", "Bearer #{jwt}")

    case return_id do
      true -> {user.id, new_conn}
      _ -> new_conn
    end
  end
end