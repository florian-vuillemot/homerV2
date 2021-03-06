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
      fn step_template -> HomerWeb.Steps.StepControllerTest.get_create_attrs(%{step_template_id: step_template.id}) end
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
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = get conn, builders_project_path(conn, :index)
      assert json_response(new_conn, 200)["projects"] == []
    end
  end

  describe "create project" do
    test "renders project when data is valid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = post conn, builders_project_path(conn, :create), project: create_attrs()
      assert %{"id" => id} = json_response(new_conn, 201)["project"]

      new_conn = get conn, builders_project_path(conn, :show, id)
      response = json_response(new_conn, 200)["project"]

      Enum.map(
        ["steps", "investors", "funders", "funding"],
        fn key -> assert nil !== Map.get(response, key) end
      )

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
        "funders" => Map.get(response, "funders"),
        "funding" => Map.get(response, "funding")}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = post conn, builders_project_path(conn, :create), project: create_attrs(@invalid_attrs)
      assert json_response(new_conn, 422)["errors"] != %{}
    end

    test "renders errors when funding_id of step is invalid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      attrs = create_attrs()
      attrs = Map.put(attrs, :funding_id, attrs.funding_id - 1)
      new_conn = post conn, builders_project_path(conn, :create), project: attrs
      assert json_response(new_conn, 422)["errors"] != %{}
    end

    test "renders errors when step are not in number", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      attrs = create_attrs()
      {_, steps} = Map.get(attrs, :steps) |> List.pop_at(0)
      attrs = Map.put(attrs, :steps, steps)
      conn = post conn, builders_project_path(conn, :create), project: attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

  end

  describe "update project" do
    setup [:create_project]

    test "renders project when data is valid", %{conn: conn, project: %Project{id: id, create_at: create_at} = project} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = put conn, builders_project_path(conn, :update, project), project: create_attrs(@update_attrs)
      #assert json_response(new_conn, 422)["errors"] != %{}
      assert response(new_conn, 403)

      new_conn = get conn, builders_project_path(conn, :show, id)
      update_project = json_response(new_conn, 200)["project"]

      project = Homer.ControllerUtilitiesTest.convert_fk(project, [:steps, :investors, :funders, :funding])

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
        "funders" => project.funders,
        "funding" => project.funding}
    end

    test "Update before assign", %{conn: conn, project: %Project{} = _project} do
      {user_id, conn} = HomerWeb.Accounts.LoginControllerTest.auth_user(conn, false, true)
      attrs = Map.replace(create_attrs(), :name, "new name")
      new_conn = post conn, builders_project_path(conn, :create), project: attrs
      %{"id" => project_id} = json_response(new_conn, 201)["project"]

      project = Homer.Builders.get_project!(project_id)
      Homer.FundersTest.set_funder(user_id, project_id)

      attrs =
        Map.put(@update_attrs, :funding_id, project.funding_id)
        |> Map.put(:id, project.id)

      new_conn = put conn, builders_project_path(conn, :update, project), project: attrs
      assert json_response(new_conn, 200)["project"] != %{}
    end

    test "renders errors when data is invalid", %{conn: conn, project: project} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = put conn, builders_project_path(conn, :update, project), project: create_attrs(@invalid_attrs)
      #assert json_response(new_conn, 422)["errors"] != %{}
      assert response(new_conn, 403)
    end

    test "Admin update before assign", %{conn: conn, project: %Project{} = _project} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn, true)
      attrs = Map.replace(create_attrs(), :name, "new name")
      new_conn = post conn, builders_project_path(conn, :create), project: attrs
      %{"id" => project_id} = json_response(new_conn, 201)["project"]

      project = Homer.Builders.get_project!(project_id)

      attrs =
        Map.put(@update_attrs, :funding_id, project.funding_id)
        |> Map.put(:id, project.id)

      new_conn = put conn, builders_project_path(conn, :update, project), project: attrs
      assert json_response(new_conn, 200)["project"] != %{}
    end
  end

  describe "delete project" do
    setup [:create_project]

    test "deletes chosen project", %{conn: conn, project: project} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn, true)
      new_conn = delete conn, builders_project_path(conn, :delete, project)
      assert response(new_conn, 204)
      assert_error_sent 404, fn ->
        get conn, builders_project_path(conn, :show, project)
      end
    end

    test "deletes chosen not allow project", %{conn: conn, project: project} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = delete conn, builders_project_path(conn, :delete, project)
      assert response(new_conn, 403)
    end
  end

  describe "access not allow" do
    test "not allow lists all projects", %{conn: conn} do
      conn = get conn, builders_project_path(conn, :index)
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow get a projects", %{conn: conn} do
      %Project{id: id} = fixture(:project)
      conn = get conn, builders_project_path(conn, :show, id)
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow create a projects", %{conn: conn} do
      conn = post conn, builders_project_path(conn, :create), user: @create_attrs
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow to update a projects", %{conn: conn} do
      user = fixture(:project)
      conn = put conn, builders_project_path(conn, :update, user), user: @update_attrs
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow to delete a projects", %{conn: conn} do
      user = fixture(:project)
      conn = delete conn, builders_project_path(conn, :delete, user)
      assert json_response(conn, 401)["message"] != %{}
    end
  end

  defp create_project(_) do
    project = fixture(:project)
    {:ok, project: project}
  end
end
