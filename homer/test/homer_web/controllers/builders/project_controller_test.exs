defmodule HomerWeb.Builders.ProjectControllerTest do
  use HomerWeb.ConnCase

  alias Homer.Builders
  alias Homer.Builders.Project

  @create_attrs %{create_at: "2010-04-17 14:00:00.000000Z", description: "some description", status: 42, to_raise: 42}
  @update_attrs %{create_at: "2011-05-18 15:01:01.000000Z", description: "some updated description", status: 43, to_raise: 43}
  @invalid_attrs %{create_at: nil, description: nil, status: nil, to_raise: nil}

  def fixture(:project) do
    {:ok, project} = Builders.create_project(@create_attrs)
    project
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all projects", %{conn: conn} do
      conn = get conn, builders_project_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create project" do
    test "renders project when data is valid", %{conn: conn} do
      conn = post conn, builders_project_path(conn, :create), project: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, builders_project_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "create_at" => "2010-04-17 14:00:00.000000Z",
        "description" => "some description",
        "status" => 42,
        "to_raise" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, builders_project_path(conn, :create), project: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update project" do
    setup [:create_project]

    test "renders project when data is valid", %{conn: conn, project: %Project{id: id} = project} do
      conn = put conn, builders_project_path(conn, :update, project), project: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, builders_project_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "create_at" => "2011-05-18 15:01:01.000000Z",
        "description" => "some updated description",
        "status" => 43,
        "to_raise" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, project: project} do
      conn = put conn, builders_project_path(conn, :update, project), project: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete project" do
    setup [:create_project]

    test "deletes chosen project", %{conn: conn, project: project} do
      conn = delete conn, builders_project_path(conn, :delete, project)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, builders_project_path(conn, :show, project)
      end
    end
  end

  defp create_project(_) do
    project = fixture(:project)
    {:ok, project: project}
  end
end
