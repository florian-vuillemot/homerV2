defmodule HomerWeb.Builders.ProjectView do
  use HomerWeb, :view
  alias HomerWeb.Builders.ProjectView

  def render("index.json", %{projects: projects}) do
    %{projects: render_many(projects, ProjectView, "project.json")}
  end

  def render("show.json", %{project: project}) do
    %{project: render_one(project, ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    %{id: project.id,
      name: project.name,
      description: project.description,
      to_raise: project.to_raise,
      create_at: project.create_at,
      status: project.status,
      steps: project.steps,
      github: project.github,
      investors: project.investors,
      funders: project.funders
    }
  end
end
