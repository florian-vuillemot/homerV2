defmodule HomerWeb.Builders.ProjectController do
  use HomerWeb, :controller

  alias Homer.Builders
  alias Homer.Builders.Project

  action_fallback HomerWeb.FallbackController

  def index(conn, _params) do
    projects = Builders.list_projects()
    render(conn, "index.json", projects: projects)
  end

  def create(conn, %{"project" => project_params}) do
    with {:ok, %Project{} = project} <- Builders.create_project(project_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", builders_project_path(conn, :show, project))
      |> render("show.json", project: project)
    end
  end

  def show(conn, %{"id" => id}) do
    project = Builders.get_project!(id)
    render(conn, "show.json", project: project)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Builders.get_project!(id)
    user =  HomerWeb.Utilities.GetId.get_id(conn) |> Homer.Accounts.get_user!
    admin = Homer.Accounts.is_admin?(user)

    case admin or Builders.is_funder(project, user) do
      true ->
        with {:ok, %Project{} = project} <- Builders.update_project(project, project_params, admin) do
          render(conn, "show.json", project: project)
        end
      _ ->
        send_resp(conn, :forbidden, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    case Homer.Accounts.is_admin?(HomerWeb.Utilities.GetId.get_id(conn)) do
      true ->
        project = Builders.get_project!(id)
        with {:ok, %Project{}} <- Builders.delete_project(project) do
          send_resp(conn, :no_content, "")
        end
      _ ->
        send_resp(conn, :forbidden, "")
    end
  end
end
