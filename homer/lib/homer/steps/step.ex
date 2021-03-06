defmodule Homer.Steps.Step do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.Steps.Step

  alias Homer.StepTemplates.StepTemplate
  alias Homer.Builders.Project
  alias Homer.StepsValidation.StepValidation

  schema "steps" do
    field :name, :string
    field :description, :string

    field :create_at, :utc_datetime
    #field :project_id, :id
    #field :step_template_id, :id
    belongs_to :project, Project
    belongs_to :step_template, StepTemplate

    has_many :steps_validation, StepValidation

    timestamps()
  end

  @doc false
  def changeset(%Step{} = step, attrs) do
    step
    |> cast(attrs, [:name, :description, :step_template_id])
    |> validate_required([:name, :description, :step_template_id])
    |> foreign_key_constraint(:step_template_id)
    |> foreign_key_constraint(:project_id)
  end
end
