defmodule HomerWeb.StepTemplates.StepTemplateController do
  use HomerWeb, :controller

  alias Homer.StepTemplates
  alias Homer.StepTemplates.StepTemplate
  alias HomerWeb.Utilities.GetId
  alias Homer.Accounts

  action_fallback HomerWeb.FallbackController

  def index(conn, _params) do
    step_templates = StepTemplates.list_step_templates()
    render(conn, "index.json", step_templates: step_templates)
  end

  def create(conn, %{"step_template" => step_template_params}) do
    case Accounts.is_admin?(GetId.get_id(conn)) do
      true ->
        with {:ok, %StepTemplate{} = step_template} <- StepTemplates.create_step_template(step_template_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", step_templates_step_template_path(conn, :show, step_template))
          |> render("show.json", step_template: step_template)
        end
      _ ->
        send_resp(conn, :forbidden, "")
    end
  end

  def show(conn, %{"id" => id}) do
    step_template = StepTemplates.get_step_template!(id)
    render(conn, "show.json", step_template: step_template)
  end

  def update(conn, %{"id" => id, "step_template" => step_template_params}) do
    case Accounts.is_admin?(GetId.get_id(conn)) do
      true ->
        step_template = StepTemplates.get_step_template!(id)

        with {:ok, %StepTemplate{} = step_template} <- StepTemplates.update_step_template(step_template, step_template_params) do
          render(conn, "show.json", step_template: step_template)
        end
      _ ->
        send_resp(conn, :forbidden, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    case Accounts.is_admin?(GetId.get_id(conn)) do
      true ->
        step_template = StepTemplates.get_step_template!(id)
        with {:ok, %StepTemplate{}} <- StepTemplates.delete_step_template(step_template) do
          send_resp(conn, :no_content, "")
        end
      _ ->
        send_resp(conn, :forbidden, "")
    end
  end
end
