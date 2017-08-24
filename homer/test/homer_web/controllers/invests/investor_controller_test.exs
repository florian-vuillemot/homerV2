defmodule HomerWeb.Invests.InvestorControllerTest do
  use HomerWeb.ConnCase

  alias Homer.Invests
  alias Homer.Invests.Investor

  @create_attrs %{comment: "some comment", funding: 42, user: 1}
  @update_attrs %{comment: "some updated comment", funding: 43, user: 1}
  @invalid_attrs %{comment: nil, funding: nil}

  def fixture(:investor) do
    {:ok, investor} = Invests.create_investor(@create_attrs)
    investor
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all investors", %{conn: conn} do
      conn = get conn, invests_investor_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create investor" do
    test "renders investor when data is valid", %{conn: conn} do
      conn = post conn, invests_investor_path(conn, :create), investor: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, invests_investor_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "comment" => "some comment",
        "funding" => 42,
        "steps_validation" => []}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, invests_investor_path(conn, :create), investor: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update investor" do
    setup [:create_investor]

    test "renders investor when data is valid", %{conn: conn, investor: %Investor{id: id} = investor} do
      conn = put conn, invests_investor_path(conn, :update, investor), investor: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, invests_investor_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "comment" => "some updated comment",
        "funding" => 43,
        "steps_validation" => []}
    end

    test "renders errors when data is invalid", %{conn: conn, investor: investor} do
      conn = put conn, invests_investor_path(conn, :update, investor), investor: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete investor" do
    setup [:create_investor]

    test "deletes chosen investor", %{conn: conn, investor: investor} do
      conn = delete conn, invests_investor_path(conn, :delete, investor)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, invests_investor_path(conn, :show, investor)
      end
    end
  end

  defp create_investor(_) do
    investor = fixture(:investor)
    {:ok, investor: investor}
  end
end
