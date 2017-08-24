defmodule HomerWeb.Builders.ProjectControllerTest do
  use HomerWeb.ConnCase

  alias Homer.Builders
  alias Homer.Builders.Project

  @create_attrs %{name: "some name", description: "some description", to_raise: 42}
  @update_attrs %{name: "some updated name", description: "some updated description", to_raise: 43, github: "some github"}
  @invalid_attrs %{name: nil, description: nil, to_raise: nil}

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
        "name" => "some name",
        "create_at" => "#{Ecto.DateTime.to_iso8601(Ecto.DateTime.utc)}.000000Z",
        "description" => "some description",
        "status" => Homer.Builders.status_projects(:create),
        "to_raise" => 42,
        "steps" => [],
        "github" => nil}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, builders_project_path(conn, :create), project: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update project" do
    setup [:create_project]

    test "renders project when data is valid", %{conn: conn, project: %Project{id: id, create_at: create_at} = project} do
      conn = put conn, builders_project_path(conn, :update, project), project: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, builders_project_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name",
        "create_at" => "#{Ecto.DateTime.to_iso8601(create_at)}.000000Z",
        "description" => "some updated description",
        "status" => Homer.Builders.status_projects(:create),
        "to_raise" => 43,
        "steps" => [],
        "github" => "some github"}
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
