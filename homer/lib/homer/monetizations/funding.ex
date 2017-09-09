defmodule Homer.Monetizations.Funding do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.Monetizations.Funding

  alias Homer.Builders.Project
  alias Homer.StepTemplates.StepTemplate
  alias Homer.InvestsAllows.InvestAllow

  schema "fundings" do
    field :create, :utc_datetime
    field :description, :string
    field :name, :string
    field :unit, :string
    field :valid, :boolean, default: false
    field :days, :integer
    field :validate, :integer

    has_many :projects, Project
    has_many :step_templates, StepTemplate
    has_many :invests_allows, InvestAllow

    timestamps()
  end

  @doc false
  def changeset(%Funding{} = funding, attrs) do
    funding
    |> cast(attrs, [:name, :description, :unit, :days, :validate])
    |> validate_required([:name, :description, :unit, :days, :validate])
    |> cast_assoc(:invests_allows)
    |> cast_assoc(:step_templates)
  end
end
