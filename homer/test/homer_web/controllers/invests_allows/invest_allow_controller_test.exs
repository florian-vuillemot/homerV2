defmodule HomerWeb.InvestsAllows.InvestAllowControllerTest do
  use HomerWeb.ConnCase

  alias Homer.InvestsAllows
  alias Homer.InvestsAllows.InvestAllow

  @create_attrs %{description: "some description", invest: 42, name: "some name"}
  @update_attrs %{description: "some updated description", invest: 43, name: "some updated name"}
  @invalid_attrs %{description: nil, invest: nil, name: nil}

  def fixture(:invest_allow) do
    {:ok, invest_allow} = InvestsAllows.create_invest_allow(@create_attrs)
    invest_allow
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all invests_allows", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = get conn, invests_allows_invest_allow_path(conn, :index)
      assert json_response(new_conn, 200)["invest_allows"] == []
    end
  end

  describe "create invest_allow" do
    test "renders invest_allow when data is valid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = post conn, invests_allows_invest_allow_path(conn, :create), invest_allow: @create_attrs
      assert %{"id" => id} = json_response(new_conn, 201)["invest_allow"]

      new_conn = get conn, invests_allows_invest_allow_path(conn, :show, id)
      assert json_response(new_conn, 200)["invest_allow"] == %{
        "id" => id,
        "description" => "some description",
        "invest" => 42,
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = post conn, invests_allows_invest_allow_path(conn, :create), invest_allow: @invalid_attrs
      assert json_response(new_conn, 422)["errors"] != %{}
    end
  end

  describe "update invest_allow" do
    setup [:create_invest_allow]

    test "renders invest_allow when data is valid", %{conn: conn, invest_allow: %InvestAllow{id: id} = invest_allow} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = put conn, invests_allows_invest_allow_path(conn, :update, invest_allow), invest_allow: @update_attrs
      assert %{"id" => ^id} = json_response(new_conn, 200)["invest_allow"]

      new_conn = get conn, invests_allows_invest_allow_path(conn, :show, id)
      assert json_response(new_conn, 200)["invest_allow"] == %{
        "id" => id,
        "description" => "some updated description",
        "invest" => 43,
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, invest_allow: invest_allow} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = put conn, invests_allows_invest_allow_path(conn, :update, invest_allow), invest_allow: @invalid_attrs
      assert json_response(new_conn, 422)["errors"] != %{}
    end
  end

  describe "delete invest_allow" do
    setup [:create_invest_allow]

    test "deletes chosen invest_allow", %{conn: conn, invest_allow: invest_allow} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = delete conn, invests_allows_invest_allow_path(conn, :delete, invest_allow)
      assert response(new_conn, 204)
      assert_error_sent 404, fn ->
        get conn, invests_allows_invest_allow_path(conn, :show, invest_allow)
      end
    end
  end

  describe "access not allow" do
    test "not allow lists all invests_allows", %{conn: conn} do
      conn = get conn, invests_allows_invest_allow_path(conn, :index)
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow get a invests_allows", %{conn: conn} do
      %InvestAllow{id: id} = fixture(:invest_allow)
      conn = get conn, invests_allows_invest_allow_path(conn, :show, id)
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow create a invests_allows", %{conn: conn} do
      conn = post conn, invests_allows_invest_allow_path(conn, :create), user: @create_attrs
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow to update a invests_allows", %{conn: conn} do
      user = fixture(:invest_allow)
      conn = put conn, invests_allows_invest_allow_path(conn, :update, user), user: @update_attrs
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow to delete a invests_allows", %{conn: conn} do
      user = fixture(:invest_allow)
      conn = delete conn, invests_allows_invest_allow_path(conn, :delete, user)
      assert json_response(conn, 401)["message"] != %{}
    end
  end

  defp create_invest_allow(_) do
    invest_allow = fixture(:invest_allow)
    {:ok, invest_allow: invest_allow}
  end
end
