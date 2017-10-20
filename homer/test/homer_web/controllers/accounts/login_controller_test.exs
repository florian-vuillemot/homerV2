defmodule HomerWeb.Accounts.LoginControllerTest do
  use HomerWeb.ConnCase

  describe "login" do
    test "test login users", %{conn: conn} do
      conn = auth_user(conn)
      conn = get conn, accounts_user_path(conn, :index)
      len_res = length(json_response(conn, 200)["users"])
      assert len_res == 1
    end
  end

  @doc """
    Create a customer and log it.
    Take a conn parameter, fill and return it.
  """
  def auth_user(conn, create_admin \\ false) do
    user = case create_admin do
      false -> Homer.AccountsTest.user_fixture(%{password: "test_password"}, true)
      _ -> Homer.AccountsTest.create_admin(%{password: "test_password"}, true)
    end
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)

    new_conn = conn
               |> Plug.Conn.put_req_header("accept", "application/json")
               |> Plug.Conn.put_req_header("authorization", "Bearer #{jwt}")

    new_conn
  end
end