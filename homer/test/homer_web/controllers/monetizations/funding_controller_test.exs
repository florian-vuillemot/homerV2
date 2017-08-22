defmodule HomerWeb.Monetizations.FundingControllerTest do
  use HomerWeb.ConnCase

  alias Homer.Monetizations
  alias Homer.Monetizations.Funding

  @create_attrs %{description: "some description", name: "some name", unit: "some unit"}
  @update_attrs %{description: "some updated description", name: "some updated name", unit: "some updated unit"}
  @invalid_attrs %{description: nil, name: nil, unit: nil}

  def fixture(:funding) do
    {:ok, funding} = Monetizations.create_funding(@create_attrs)
    funding
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all fundings", %{conn: conn} do
      conn = get conn, monetizations_funding_path(conn, :index)
      assert json_response(conn, 200)["fundings"] == []
    end
  end

  describe "create funding" do
    test "renders funding when data is valid", %{conn: conn} do
      conn = post conn, monetizations_funding_path(conn, :create), funding: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["funding"]


      conn = get conn, monetizations_funding_path(conn, :show, id)
      response = json_response(conn, 200)["funding"]
      assert response == %{
        "id" => id,
        "create" => response["create"],
        "description" => "some description",
        "name" => "some name",
        "unit" => "some unit",
        "valid" => false}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, monetizations_funding_path(conn, :create), funding: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update funding" do
    setup [:create_funding]

    test "renders funding when data is valid", %{conn: conn, funding: %Funding{id: id} = funding} do
      conn = put conn, monetizations_funding_path(conn, :update, funding), funding: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["funding"]

      conn = get conn, monetizations_funding_path(conn, :show, id)
      response = json_response(conn, 200)["funding"]
      assert response == %{
        "id" => id,
        "create" => response["create"],
        "description" => "some updated description",
        "name" => "some updated name",
        "unit" => "some updated unit",
        "valid" => false}
    end

    test "renders errors when data is invalid", %{conn: conn, funding: funding} do
      conn = put conn, monetizations_funding_path(conn, :update, funding), funding: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete funding" do
    setup [:create_funding]

    test "deletes chosen funding", %{conn: conn, funding: funding} do
      conn = delete conn, monetizations_funding_path(conn, :delete, funding)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, monetizations_funding_path(conn, :show, funding)
      end
    end
  end

  defp create_funding(_) do
    funding = fixture(:funding)
    {:ok, funding: funding}
  end
end
