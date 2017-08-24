defmodule HomerWeb.Funders.FunderControllerTest do
  use HomerWeb.ConnCase

  alias Homer.Funders
  alias Homer.Funders.Funder

  @create_attrs %{status: "Creator"}
  @update_attrs %{status: "Worker"}
  @invalid_attrs %{status: nil}

  def fixture(:funder) do
    {:ok, funder} = Funders.create_funder(@create_attrs)
    funder
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all funders", %{conn: conn} do
      conn = get conn, funders_funder_path(conn, :index)
      assert json_response(conn, 200)["funders"] == []
    end
  end

  describe "create funder" do
    test "renders funder when data is valid", %{conn: conn} do
      conn = post conn, funders_funder_path(conn, :create), funder: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["funder"]

      conn = get conn, funders_funder_path(conn, :show, id)
      assert json_response(conn, 200)["funder"] == %{
        "id" => id,
        "status" => "Creator",
        "project" => nil,
        "user" => nil}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, funders_funder_path(conn, :create), funder: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update funder" do
    setup [:create_funder]

    test "renders funder when data is valid", %{conn: conn, funder: %Funder{id: id} = funder} do
      conn = put conn, funders_funder_path(conn, :update, funder), funder: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["funder"]

      conn = get conn, funders_funder_path(conn, :show, id)
      assert json_response(conn, 200)["funder"] == %{
        "id" => id,
        "status" => "Worker",
        "project" => nil,
        "user" => nil}
    end

    test "renders errors when data is invalid", %{conn: conn, funder: funder} do
      conn = put conn, funders_funder_path(conn, :update, funder), funder: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete funder" do
    setup [:create_funder]

    test "deletes chosen funder", %{conn: conn, funder: funder} do
      conn = delete conn, funders_funder_path(conn, :delete, funder)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, funders_funder_path(conn, :show, funder)
      end
    end
  end

  defp create_funder(_) do
    funder = fixture(:funder)
    {:ok, funder: funder}
  end
end
