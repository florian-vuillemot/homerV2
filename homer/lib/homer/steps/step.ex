defmodule Homer.Steps.Step do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.Steps.Step


  schema "steps" do
    field :create_at, :utc_datetime
    field :project_id, :id
    field :step_template_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Step{} = step, attrs) do
    step
    |> cast(attrs, [:create_at])
    |> validate_required([:create_at])
  end
end
