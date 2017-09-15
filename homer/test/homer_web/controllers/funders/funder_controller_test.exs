defmodule HomerWeb.Funders.FunderControllerTest do
  use HomerWeb.ConnCase

  alias Homer.Funders
  alias Homer.Funders.Funder

  @create_attrs %{status: "Creator"}
  @update_attrs %{status: "Worker"}
  @invalid_attrs %{status: nil}

  def fixture(:funder) do
    {:ok, funder} = Funders.create_funder(valid_attrs())
    funder
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all funders", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = get conn, funders_funder_path(conn, :index)
      assert json_response(new_conn, 200)["funders"] == []
    end
  end

  describe "create funder" do
    test "renders funder when data is valid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = post conn, funders_funder_path(conn, :create), funder: valid_attrs(@create_attrs)
      assert %{"id" => id} = json_response(new_conn, 201)["funder"]

      new_conn = get conn, funders_funder_path(conn, :show, id)
      funder = json_response(new_conn, 200)["funder"]

      assert Map.get(funder, "project") != nil
      assert Map.get(funder, "user") != nil

      assert funder == %{
        "id" => id,
        "status" => "Creator",
        "project" => Map.get(funder, "project"),
        "user" => Map.get(funder, "user")}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = post conn, funders_funder_path(conn, :create), funder: valid_attrs(@invalid_attrs)
      assert json_response(new_conn, 422)["errors"] != %{}
    end

    test "renders errors when fk is invalid", %{conn: conn} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      funder_attrs = valid_attrs(@create_attrs)

      bad_user_id = Map.put(funder_attrs, :user_id, Map.get(funder_attrs, :user_id) - 1)
      bad_project_id = Map.put(funder_attrs, :project_id, Map.get(funder_attrs, :project_id) - 1)

      new_conn = post conn, funders_funder_path(conn, :create), funder: bad_user_id
      assert json_response(new_conn, 422)["errors"] != %{}

      new_conn = post conn, funders_funder_path(conn, :create), funder: bad_project_id
      assert json_response(new_conn, 422)["errors"] != %{}
    end

  end

  describe "update funder" do
    setup [:create_funder]

    test "renders funder when data is valid", %{conn: conn, funder: %Funder{id: id} = funder} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = put conn, funders_funder_path(conn, :update, funder), funder: valid_attrs(@update_attrs, funder)
      assert %{"id" => ^id} = json_response(new_conn, 200)["funder"]

      new_conn = get conn, funders_funder_path(conn, :show, id)
      funder = json_response(new_conn, 200)["funder"]

      assert Map.get(funder, "project") != nil
      assert Map.get(funder, "user") != nil

      assert funder == %{
        "id" => id,
        "status" => "Worker",
        "project" => Map.get(funder, "project"),
        "user" => Map.get(funder, "user")}
    end

    test "renders errors when data is invalid", %{conn: conn, funder: funder} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = put conn, funders_funder_path(conn, :update, funder), funder: valid_attrs(@invalid_attrs)
      assert json_response(new_conn, 422)["errors"] != %{}
    end
  end

  describe "delete funder" do
    setup [:create_funder]

    test "deletes chosen funder", %{conn: conn, funder: funder} do
      conn = HomerWeb.Accounts.LoginControllerTest.auth_user(conn)
      new_conn = delete conn, funders_funder_path(conn, :delete, funder)
      assert response(new_conn, 204)
      assert_error_sent 404, fn ->
        get conn, funders_funder_path(conn, :show, funder)
      end
    end
  end

  defp create_funder(_) do
    funder = fixture(:funder)
    {:ok, funder: funder}
  end

  defp valid_attrs(attrs \\ @create_attrs, funder \\ nil) do
    case nil !== funder do
      true ->
        attrs
          |> Map.put(:project_id, funder.project_id)
          |> Map.put(:user_id, funder.user_id)
      _ ->
        project = Homer.BuildersTest.project_fixture(%{}, true)
        user = Homer.AccountsTest.user_fixture(%{}, true)
        attrs
          |> Map.put(:project_id, project.id)
          |> Map.put(:user_id, user.id)
    end
  end
end
