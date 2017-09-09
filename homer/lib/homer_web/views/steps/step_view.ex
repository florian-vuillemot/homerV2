defmodule HomerWeb.Steps.StepView do
  use HomerWeb, :view
  alias HomerWeb.Steps.StepView

  def render("index.json", %{steps: steps}) do
    %{steps: render_many(steps, StepView, "step.json")}
  end

  def render("show.json", %{step: step}) do
    %{step: render_one(step, StepView, "step.json")}
  end

  def render("step.json", %{step: step}) do
    %{id: step.id,
      create_at: step.create_at}
  end
end
