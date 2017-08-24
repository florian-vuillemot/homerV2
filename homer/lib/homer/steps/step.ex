defmodule Homer.Steps.Step do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.Steps.Step

  alias Homer.StepTemplates.StepTemplate
  alias Homer.Builders.Project

  schema "steps" do
    field :create_at, :utc_datetime
    #field :project_id, :id
    #field :step_template_id, :id
    belongs_to :project, Project
    belongs_to :step_template, StepTemplate

    timestamps()
  end

  @doc false
  def changeset(%Step{} = step, attrs) do
    step
    |> cast(attrs, [])
    |> validate_required([])
  end
end
