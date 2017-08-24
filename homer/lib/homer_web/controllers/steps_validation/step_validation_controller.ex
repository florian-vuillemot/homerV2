defmodule HomerWeb.StepsValidation.StepValidationController do
  use HomerWeb, :controller

  alias Homer.StepsValidation
  alias Homer.StepsValidation.StepValidation

  action_fallback HomerWeb.FallbackController

  def index(conn, _params) do
    steps_validation = StepsValidation.list_steps_validation()
    render(conn, "index.json", steps_validation: steps_validation)
  end

  def create(conn, %{"step_validation" => step_validation_params}) do
    with {:ok, %StepValidation{} = step_validation} <- StepsValidation.create_step_validation(step_validation_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", steps_validation_step_validation_path(conn, :show, step_validation))
      |> render("show.json", step_validation: step_validation)
    end
  end

  def show(conn, %{"id" => id}) do
    step_validation = StepsValidation.get_step_validation!(id)
    render(conn, "show.json", step_validation: step_validation)
  end

  def update(conn, %{"id" => id, "step_validation" => step_validation_params}) do
    step_validation = StepsValidation.get_step_validation!(id)

    with {:ok, %StepValidation{} = step_validation} <- StepsValidation.update_step_validation(step_validation, step_validation_params) do
      render(conn, "show.json", step_validation: step_validation)
    end
  end

  def delete(conn, %{"id" => id}) do
    step_validation = StepsValidation.get_step_validation!(id)
    with {:ok, %StepValidation{}} <- StepsValidation.delete_step_validation(step_validation) do
      send_resp(conn, :no_content, "")
    end
  end
end
