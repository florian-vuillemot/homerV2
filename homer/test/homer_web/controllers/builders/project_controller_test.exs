defmodule HomerWeb.Builders.ProjectControllerTest do
  use HomerWeb.ConnCase

  alias Homer.Builders
  alias Homer.Builders.Project

  @create_attrs %{name: "some name", description: "some description", to_raise: 42}
  @update_attrs %{name: "some updated name", description: "some updated description", to_raise: 43, github: "some github"}
  @invalid_attrs %{name: nil, description: nil, to_raise: nil}

  def create_attrs(attrs \\ @create_attrs) do
    funding = Homer.MonetizationsTest.funding_fixture

    steps = Enum.map(
      funding.step_templates,
      fn step_template -> %{step_template_id: step_template.id} end
    )

    attrs
    |> Map.put(:steps, steps)
    |> Map.put(:funding_id, funding.id)
  end

  def fixture(:project) do
    {:ok, project} = Builders.create_project(create_attrs())

    project
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all projects", %{conn: conn} do
      conn = get conn, builders_project_path(conn, :index)
      assert json_response(conn, 200)["projects"] == []
    end
  end

  describe "create project" do
    test "renders project when data is valid", %{conn: conn} do
      conn = post conn, builders_project_path(conn, :create), project: create_attrs()
      assert %{"id" => id} = json_response(conn, 201)["project"]

      conn = get conn, builders_project_path(conn, :show, id)
      response = json_response(conn, 200)["project"]

      assert response == %{
        "id" => id,
        "name" => "some name",
        "create_at" => "#{Ecto.DateTime.to_iso8601(Ecto.DateTime.utc)}.000000Z",
        "description" => "some description",
        "status" => Homer.Builders.status_projects(:create),
        "to_raise" => 42,
        "steps" => Map.get(response, "steps"),
        "github" => nil,
        "investors" => Map.get(response, "investors"),
        "funders" => Map.get(response, "funders")}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, builders_project_path(conn, :create), project: create_attrs(@invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when funding_id of step is invalid", %{conn: conn} do
      attrs = create_attrs()
      attrs = Map.put(attrs, :funding_id, attrs.funding_id - 1)
      conn = post conn, builders_project_path(conn, :create), project: attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

  end

  describe "update project" do
    setup [:create_project]

    test "renders project when data is valid", %{conn: conn, project: %Project{id: id, create_at: create_at} = project} do
      conn = put conn, builders_project_path(conn, :update, project), project: create_attrs(@update_attrs)
      assert json_response(conn, 422)["errors"] != %{}

      conn = get conn, builders_project_path(conn, :show, id)
      update_project = json_response(conn, 200)["project"]

      project = Homer.ControllerUtilitiesTest.convert_fk(project, [:steps, :investors, :funders])

      assert update_project == %{
        "id" => id,
        "name" => "some name",
        "create_at" => "#{Ecto.DateTime.to_iso8601(create_at)}.000000Z",
        "description" => "some description",
        "status" => Homer.Builders.status_projects(:create),
        "to_raise" => 43,
        "steps" => project.steps,
        "github" => nil,
        "investors" => project.investors,
        "funders" => project.funders}
    end

    test "renders errors when data is invalid", %{conn: conn, project: project} do
      conn = put conn, builders_project_path(conn, :update, project), project: create_attrs(@invalid_attrs)
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
