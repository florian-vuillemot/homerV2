defmodule HomerWeb.StepsValidation.StepValidationControllerTest do
  use HomerWeb.ConnCase

  alias Homer.StepsValidation
  alias Homer.StepsValidation.StepValidation

  @create_attrs %{comment: "some comment", valid: 42}
  @update_attrs %{comment: "some updated comment", valid: 43}
  @invalid_attrs %{comment: nil, valid: nil}

  def fixture(:step_validation) do
    {:ok, step_validation} = StepsValidation.create_step_validation(@create_attrs)
    step_validation
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all steps_validation", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = get conn, steps_validation_step_validation_path(conn, :index)
      assert json_response(new_conn, 200)["data"] == []
    end
  end

  describe "create step_validation" do
    test "renders step_validation when data is valid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = post conn, steps_validation_step_validation_path(conn, :create), step_validation: @create_attrs
      assert %{"id" => id} = json_response(new_conn, 201)["data"]

      new_conn = get conn, steps_validation_step_validation_path(conn, :show, id)
      assert json_response(new_conn, 200)["data"] == %{
        "id" => id,
        "comment" => "some comment",
        "valid" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = post conn, steps_validation_step_validation_path(conn, :create), step_validation: @invalid_attrs
      assert json_response(new_conn, 422)["errors"] != %{}
    end
  end

  describe "update step_validation" do
    setup [:create_step_validation]

    test "renders step_validation when data is valid", %{conn: conn, step_validation: %StepValidation{id: id} = step_validation} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = put conn, steps_validation_step_validation_path(conn, :update, step_validation), step_validation: @update_attrs
      assert %{"id" => ^id} = json_response(new_conn, 200)["data"]

      new_conn = get conn, steps_validation_step_validation_path(conn, :show, id)
      assert json_response(new_conn, 200)["data"] == %{
        "id" => id,
        "comment" => "some updated comment",
        "valid" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, step_validation: step_validation} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = put conn, steps_validation_step_validation_path(conn, :update, step_validation), step_validation: @invalid_attrs
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

  defp create_step_validation(_) do
    step_validation = fixture(:step_validation)
    {:ok, step_validation: step_validation}
  end
end
