defmodule HomerWeb.StepTemplates.StepTemplateControllerTest do
  use HomerWeb.ConnCase

  alias Homer.StepTemplates
  alias Homer.StepTemplates.StepTemplate

  @create_attrs %{description: "some description", name: "some name", rank: 42}
  @update_attrs %{description: "some updated description", name: "some updated name", rank: 43}
  @invalid_attrs %{description: nil, name: nil, rank: nil}

  def fixture(:step_template) do
    {:ok, step_template} = StepTemplates.create_step_template(@create_attrs)
    step_template
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all step_templates", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = get conn, step_templates_step_template_path(conn, :index)
      assert json_response(new_conn, 200)["data"] == []
    end
  end

  describe "create step_template" do
    test "renders step_template when data is valid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn, true)
      new_conn = post conn, step_templates_step_template_path(conn, :create), step_template: @create_attrs
      assert %{"id" => id} = json_response(new_conn, 201)["data"]

      new_conn = get conn, step_templates_step_template_path(conn, :show, id)
      assert json_response(new_conn, 200)["data"] == %{
        "id" => id,
        "description" => "some description",
        "name" => "some name",
        "rank" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn, true)
      new_conn = post conn, step_templates_step_template_path(conn, :create), step_template: @invalid_attrs
      assert json_response(new_conn, 422)["errors"] != %{}
    end
  end

  describe "update step_template" do
    setup [:create_step_template]

    test "renders step_template when data is valid", %{conn: conn, step_template: %StepTemplate{id: id} = step_template} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn, true)
      new_conn = put conn, step_templates_step_template_path(conn, :update, step_template), step_template: @update_attrs
      assert %{"id" => ^id} = json_response(new_conn, 200)["data"]

      new_conn = get conn, step_templates_step_template_path(conn, :show, id)
      assert json_response(new_conn, 200)["data"] == %{
        "id" => id,
        "description" => "some updated description",
        "name" => "some updated name",
        "rank" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, step_template: step_template} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn, true)
      new_conn = put conn, step_templates_step_template_path(conn, :update, step_template), step_template: @invalid_attrs
      assert json_response(new_conn, 422)["errors"] != %{}
    end
  end

  describe "delete step_template" do
    setup [:create_step_template]

    test "deletes chosen step_template", %{conn: conn, step_template: step_template} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn, true)
      new_conn = delete conn, step_templates_step_template_path(conn, :delete, step_template)
      assert response(new_conn, 204)
      assert_error_sent 404, fn ->
        get conn, step_templates_step_template_path(conn, :show, step_template)
      end
    end
  end

  describe "access not allow" do
    test "not allow lists all step_template", %{conn: conn} do
      conn = get conn, step_templates_step_template_path(conn, :index)
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow get a step_template", %{conn: conn} do
      %StepTemplate{id: id} = fixture(:step_template)
      conn = get conn, step_templates_step_template_path(conn, :show, id)
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow create a step_template", %{conn: conn} do
      conn = post conn, step_templates_step_template_path(conn, :create), user: @create_attrs
      assert json_response(conn, 401)["message"] != %{}
    end

    test "cant create", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = post conn, step_templates_step_template_path(conn, :create), step_template: @create_attrs
      assert new_conn.status == 403
    end

    test "not allow to update a step_template", %{conn: conn} do
      user = fixture(:step_template)
      conn = put conn, step_templates_step_template_path(conn, :update, user), user: @update_attrs
      assert json_response(conn, 401)["message"] != %{}
    end

    test "cant update", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      step_template = fixture(:step_template)
      new_conn = put conn, step_templates_step_template_path(conn, :update, step_template), step_template: @update_attrs
      assert new_conn.status == 403
    end

    test "not allow to delete a step_template", %{conn: conn} do
      step_template = fixture(:step_template)
      conn = delete conn, step_templates_step_template_path(conn, :delete, step_template)
      assert json_response(conn, 401)["message"] != %{}
    end

    test "cant delete", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      step_template = fixture(:step_template)
      new_conn = delete conn, step_templates_step_template_path(conn, :delete, step_template)
      assert new_conn.status == 403
    end
  end

  defp create_step_template(_) do
    step_template = fixture(:step_template)
    {:ok, step_template: step_template}
  end
end
