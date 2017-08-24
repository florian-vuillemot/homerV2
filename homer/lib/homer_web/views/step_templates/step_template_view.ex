defmodule HomerWeb.StepTemplates.StepTemplateView do
  use HomerWeb, :view
  alias HomerWeb.StepTemplates.StepTemplateView

  def render("index.json", %{step_templates: step_templates}) do
    %{data: render_many(step_templates, StepTemplateView, "step_template.json")}
  end

  def render("show.json", %{step_template: step_template}) do
    %{data: render_one(step_template, StepTemplateView, "step_template.json")}
  end

  def render("step_template.json", %{step_template: step_template}) do
    %{id: step_template.id,
      name: step_template.name,
      description: step_template.description,
      rank: step_template.rank}
  end
end
