defmodule Homer.StepTemplates.StepTemplate do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.StepTemplates.StepTemplate


  schema "step_templates" do
    field :description, :string
    field :name, :string
    field :rank, :integer
    field :funding_id, :id

    timestamps()
  end

  @doc false
  def changeset(%StepTemplate{} = step_template, attrs) do
    step_template
    |> cast(attrs, [:name, :description, :rank])
    |> validate_required([:name, :description, :rank])
  end
end
