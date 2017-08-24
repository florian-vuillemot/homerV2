defmodule Homer.StepsValidation.StepValidation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.StepsValidation.StepValidation


  schema "steps_validation" do
    field :comment, :string
    field :valid, :integer
    field :step_id, :id
    field :investor_id, :id

    timestamps()
  end

  @doc false
  def changeset(%StepValidation{} = step_validation, attrs) do
    step_validation
    |> cast(attrs, [:valid, :comment])
    |> validate_required([:valid, :comment])
  end
end
