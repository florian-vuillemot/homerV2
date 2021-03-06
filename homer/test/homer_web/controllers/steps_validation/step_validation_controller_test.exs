defmodule HomerWeb.StepsValidation.StepValidationControllerTest do
  use HomerWeb.ConnCase

  alias Homer.StepsValidation
  alias Homer.StepsValidation.StepValidation

  @create_attrs %{comment: "some comment", valid: 42}
  #@update_attrs %{comment: "some updated comment", valid: 43}
  @invalid_attrs %{comment: nil, valid: nil}

  def create_attrs(attrs \\ @create_attrs) do
    Homer.StepsValidationTest.fixture(attrs)
  end


  def fixture(:step_validation) do
    {:ok, step_validation} = StepsValidation.create_step_validation(create_attrs(@create_attrs))
    step_validation
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all steps_validation", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = get conn, steps_validation_step_validation_path(conn, :index)
      assert json_response(new_conn, 200)["step_validation"] == []
    end
  end

  describe "create step_validation" do
    test "renders step_validation when data is valid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = post conn, steps_validation_step_validation_path(conn, :create), step_validation: create_attrs(@create_attrs)
      assert %{"id" => id} = json_response(new_conn, 201)["step_validation"]

      new_conn = get conn, steps_validation_step_validation_path(conn, :show, id)
      assert json_response(new_conn, 200)["step_validation"] == %{
        "id" => id,
        "comment" => "some comment",
        "valid" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = post conn, steps_validation_step_validation_path(conn, :create), step_validation: create_attrs(@invalid_attrs)
      assert json_response(new_conn, 422)["errors"] != %{}
    end

    test "renders multiple step validation", %{conn: conn} do
      attrs = create_attrs(@create_attrs)
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = post conn, steps_validation_step_validation_path(conn, :create), step_validation: attrs
      assert %{"id" => _} = json_response(new_conn, 201)["step_validation"]

      new_conn = post conn, steps_validation_step_validation_path(conn, :create), step_validation: attrs
      assert json_response(new_conn, 422)["errors"] != %{}

      new_conn = post conn, steps_validation_step_validation_path(conn, :create), step_validation: attrs
      assert json_response(new_conn, 422)["errors"] != %{}
    end
  end

'''
  describe "update step_validation" do
    setup [:create_step_validation]

    test "renders step_validation when data is valid", %{conn: conn, step_validation: %StepValidation{id: id} = step_validation} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = put conn, steps_validation_step_validation_path(conn, :update, step_validation), step_validation: create_attrs(@update_attrs)
      assert %{"id" => ^id} = json_response(new_conn, 200)["step_validation"]

      new_conn = get conn, steps_validation_step_validation_path(conn, :show, id)
      assert json_response(new_conn, 200)["step_validation"] == %{
        "id" => id,
        "comment" => "some updated comment",
        "valid" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, step_validation: step_validation} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = put conn, steps_validation_step_validation_path(conn, :update, step_validation), step_validation: create_attrs(@invalid_attrs)
      assert json_response(new_conn, 422)["errors"] != %{}
    end
  end

  describe "delete step_validation" do
    setup [:create_step_validation]

    test "deletes chosen step_validation", %{conn: conn, step_validation: step_validation} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = delete conn, steps_validation_step_validation_path(conn, :delete, step_validation)
      assert response(new_conn, 204)
      assert_error_sent 404, fn ->
        get conn, steps_validation_step_validation_path(conn, :show, step_validation)
      end
    end
  end
'''

  describe "access not allow" do
    test "not allow lists all step_validation", %{conn: conn} do
      conn = get conn, steps_validation_step_validation_path(conn, :index)
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow get a step_validation", %{conn: conn} do
      %StepValidation{id: id} = fixture(:step_validation)
      conn = get conn, steps_validation_step_validation_path(conn, :show, id)
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow create a step_validation", %{conn: conn} do
      conn = post conn, steps_validation_step_validation_path(conn, :create), user: create_attrs(@create_attrs)
      assert json_response(conn, 401)["message"] != %{}
    end
'''
    test "not allow to update a step_validation", %{conn: conn} do
      user = fixture(:step_validation)
      conn = put conn, steps_validation_step_validation_path(conn, :update, user), user: create_attrs(@update_attrs)
      assert json_response(conn, 401)["message"] != %{}
    end

    test "not allow to delete a step_validation", %{conn: conn} do
      user = fixture(:step_validation)
      conn = delete conn, steps_validation_step_validation_path(conn, :delete, user)
      assert json_response(conn, 401)["message"] != %{}
    end
  '''
  end
'''
  defp create_step_validation(_) do
    step_validation = fixture(:step_validation)
    {:ok, step_validation: step_validation}
  end
  '''
end
