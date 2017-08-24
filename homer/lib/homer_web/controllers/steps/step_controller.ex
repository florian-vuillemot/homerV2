defmodule HomerWeb.Steps.StepController do
  use HomerWeb, :controller

  alias Homer.Steps
  alias Homer.Steps.Step

  action_fallback HomerWeb.FallbackController

  def index(conn, _params) do
    steps = Steps.list_steps()
    render(conn, "index.json", steps: steps)
  end

  def create(conn, %{"step" => step_params}) do
    with {:ok, %Step{} = step} <- Steps.create_step(step_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", steps_step_path(conn, :show, step))
      |> render("show.json", step: step)
    end
  end

  def show(conn, %{"id" => id}) do
    step = Steps.get_step!(id)
    render(conn, "show.json", step: step)
  end

  def update(conn, %{"id" => id, "step" => step_params}) do
    step = Steps.get_step!(id)

    with {:ok, %Step{} = step} <- Steps.update_step(step, step_params) do
      render(conn, "show.json", step: step)
    end
  end

  def delete(conn, %{"id" => id}) do
    step = Steps.get_step!(id)
    with {:ok, %Step{}} <- Steps.delete_step(step) do
      send_resp(conn, :no_content, "")
    end
  end
end
