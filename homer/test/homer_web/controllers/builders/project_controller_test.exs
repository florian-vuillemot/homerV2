defmodule HomerWeb.Builders.ProjectControllerTest do
  use HomerWeb.ConnCase

  alias Homer.Builders
  alias Homer.Builders.Project

  @create_attrs %{name: "some name", description: "some description", to_raise: 42,
    steps: [
      %{}
    ]
  }
  @update_attrs %{name: "some updated name", description: "some updated description", to_raise: 43, github: "some github"}
  @invalid_attrs %{name: nil, description: nil, to_raise: nil}

  def fixture(:project) do
    funding = Homer.MonetizationsTest.funding_fixture

    {:ok, project} =
      Map.put(@create_attrs, :funding_id, funding.id)
      |> Builders.create_project()

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
      conn = post conn, builders_project_path(conn, :create), project: get_valid_attrs(conn, @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["project"]

      conn = get conn, builders_project_path(conn, :show, id)
      response = json_response(conn, 200)["project"]

      Homer.ModelUtilitiesTest.test_lengths(response, [
        {"steps", 1}, {"investors", 0}, {"funders", 0}
      ])

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
      conn = post conn, builders_project_path(conn, :create), project: get_valid_attrs(conn, @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update project" do
    setup [:create_project]

    test "renders project when data is valid", %{conn: conn, project: %Project{id: id, create_at: create_at, funding_id: funding_id} = project} do
      project_attrs = Map.put(@update_attrs, :funding_id, funding_id)
      #IO.inspect(project_attrs)
      conn = put conn, builders_project_path(conn, :update, project), project: project_attrs
      assert json_response(conn, 422)["errors"] != %{}

      conn = get conn, builders_project_path(conn, :show, id)
      update_project = json_response(conn, 200)["project"]

      project = Homer.ControllerUtilitiesTest.convert_fk(project, [:steps, :investors, :funders])
#IO.inspect project
      assert update_project == %{
        "id" => id,
        "name" => "some name",
        "create_at" => "#{Ecto.DateTime.to_iso8601(create_at)}.000000Z",
        "description" => "some description",
        "status" => Homer.Builders.status_projects(:create),
        "to_raise" => 42,
        "steps" => project.steps,
        "github" => nil,
        "investors" => project.investors,
        "funders" => project.funders}
    end

    test "renders errors when data is invalid", %{conn: conn, project: project} do
      conn = put conn, builders_project_path(conn, :update, project), project: get_valid_attrs(conn, @invalid_attrs)
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

  defp get_valid_attrs(conn, attrs) do
    funding_attrs = %{description: "some description", name: "some name", unit: "some unit", days: 10, validate: 80}
    conn = post conn, monetizations_funding_path(conn, :create), funding: funding_attrs
    assert %{"id" => id} = json_response(conn, 201)["funding"]

    Map.put(attrs, :funding_id, id)
  end
end
