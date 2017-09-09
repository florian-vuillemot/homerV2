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
      conn = get conn, invests_allows_invest_allow_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create invest_allow" do
    test "renders invest_allow when data is valid", %{conn: conn} do
      conn = post conn, invests_allows_invest_allow_path(conn, :create), invest_allow: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, invests_allows_invest_allow_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => "some description",
        "invest" => 42,
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, invests_allows_invest_allow_path(conn, :create), invest_allow: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update invest_allow" do
    setup [:create_invest_allow]

    test "renders invest_allow when data is valid", %{conn: conn, invest_allow: %InvestAllow{id: id} = invest_allow} do
      conn = put conn, invests_allows_invest_allow_path(conn, :update, invest_allow), invest_allow: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, invests_allows_invest_allow_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => "some updated description",
        "invest" => 43,
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, invest_allow: invest_allow} do
      conn = put conn, invests_allows_invest_allow_path(conn, :update, invest_allow), invest_allow: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete invest_allow" do
    setup [:create_invest_allow]

    test "deletes chosen invest_allow", %{conn: conn, invest_allow: invest_allow} do
      conn = delete conn, invests_allows_invest_allow_path(conn, :delete, invest_allow)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, invests_allows_invest_allow_path(conn, :show, invest_allow)
      end
    end
  end

  defp create_invest_allow(_) do
    invest_allow = fixture(:invest_allow)
    {:ok, invest_allow: invest_allow}
  end
end
