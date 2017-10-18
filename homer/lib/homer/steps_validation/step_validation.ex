defmodule Homer.StepsValidation.StepValidation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.StepsValidation.StepValidation

  alias Homer.Steps.Step
  alias Homer.Invests.Investor

  schema "steps_validation" do
    field :comment, :string
    field :valid, :integer
    #field :step_id, :id
    #field :investor_id, :id
    belongs_to :step, Step
    belongs_to :investor, Investor

    timestamps()
  end

  @doc false
  def changeset(%StepValidation{} = step_validation, attrs) do
    step_validation
    |> cast(attrs, [:valid, :comment, :step_id, :investor_id])
    |> validate_required([:valid, :comment, :step_id, :investor_id])
    |> foreign_key_constraint(:step_id)
    |> foreign_key_constraint(:investor_id)
  end
end
