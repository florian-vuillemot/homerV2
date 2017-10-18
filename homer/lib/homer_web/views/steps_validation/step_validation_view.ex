defmodule HomerWeb.StepsValidation.StepValidationView do
  use HomerWeb, :view
  alias HomerWeb.StepsValidation.StepValidationView

  def render("index.json", %{steps_validation: steps_validation}) do
    %{step_validation: render_many(steps_validation, StepValidationView, "step_validation.json")}
  end

  def render("show.json", %{step_validation: step_validation}) do
    %{step_validation: render_one(step_validation, StepValidationView, "step_validation.json")}
  end

  def render("step_validation.json", %{step_validation: step_validation}) do
    %{id: step_validation.id,
      valid: step_validation.valid,
      comment: step_validation.comment}
  end
end
