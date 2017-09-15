defmodule HomerWeb.Invests.InvestorControllerTest do
  use HomerWeb.ConnCase

  alias Homer.Invests
  alias Homer.Invests.Investor

  @create_attrs %{comment: "some comment", user: 1}
  @update_attrs %{comment: "some updated comment", user: 1}
  @invalid_attrs %{comment: nil, user: nil}

  def fixture(:investor) do
    {:ok, investor} = Invests.create_investor(valid_attrs())
    investor
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all investors", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = get conn, invests_investor_path(conn, :index)
      assert json_response(new_conn, 200)["investors"] == []
    end
  end

  describe "create investor" do
    test "renders investor when data is valid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = post conn, invests_investor_path(conn, :create), investor: valid_attrs()
      investor = json_response(new_conn, 201)["investor"]
      assert %{"id" => id} = investor

      new_conn = get conn, invests_investor_path(conn, :show, id)
      assert json_response(new_conn, 200)["investor"] == %{
        "id" => id,
        "comment" => "some comment",
        "steps_validation" => Map.get(investor, "steps_validation"),
        "invest_allow" => Map.get(investor, "invest_allow"),
        "project" => Map.get(investor, "project"),
        "user" => Map.get(investor, "user")}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = post conn, invests_investor_path(conn, :create), investor: valid_attrs(@invalid_attrs)
      assert json_response(new_conn, 422)["errors"] != %{}
    end

    test "renders errors when fk is invalid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      attrs = valid_attrs()
                    |> Map.put(:invest_allow_id, -1)
                    |> Map.put(:project_id, -1)
                    |> Map.put(:user_id, -1)

      new_conn = post conn, invests_investor_path(conn, :create), investor: attrs
      assert json_response(new_conn, 422)["errors"] != %{}
    end
  end

  describe "update investor" do
    setup [:create_investor]

    test "renders investor when data is valid", %{conn: conn, investor: %Investor{id: id} = investor} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = put conn, invests_investor_path(conn, :update, investor), investor: valid_attrs(@update_attrs)
      investor = json_response(new_conn, 200)["investor"]
      assert %{"id" => ^id} = investor

      new_conn = get conn, invests_investor_path(conn, :show, id)
      assert json_response(new_conn, 200)["investor"] == %{
        "id" => id,
        "comment" => "some updated comment",
        "steps_validation" => Map.get(investor, "steps_validation"),
        "invest_allow" => Map.get(investor, "invest_allow"),
        "project" => Map.get(investor, "project"),
        "user" => Map.get(investor, "user")}
    end

    test "renders errors when data is invalid", %{conn: conn, investor: investor} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = put conn, invests_investor_path(conn, :update, investor), investor: valid_attrs(@invalid_attrs)
      assert json_response(new_conn, 422)["errors"] != %{}
    end
  end

  describe "delete investor" do
    setup [:create_investor]

    test "deletes chosen investor", %{conn: conn, investor: investor} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = delete conn, invests_investor_path(conn, :delete, investor)
      assert response(new_conn, 204)
      assert_error_sent 404, fn ->
        get conn, invests_investor_path(conn, :show, investor)
      end
    end
  end

  defp create_investor(_) do
    investor = fixture(:investor)
    {:ok, investor: investor}
  end

  defp valid_attrs(attrs \\ @create_attrs) do
    project = Homer.BuildersTest.project_fixture(%{}, true)
    user = Homer.AccountsTest.user_fixture(%{}, true)
    invests_allow = Homer.InvestsAllowsTest.invest_allow_fixture

    attrs = attrs
            |> Map.put(:project_id, project.id)
            |> Map.put(:user_id, user.id)
            |> Map.put(:invest_allow_id, invests_allow.id)

    attrs
  end
end
