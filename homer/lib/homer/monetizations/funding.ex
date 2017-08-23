defmodule Homer.Monetizations.Funding do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.Monetizations.Funding

  alias Homer.Builders.Project

  schema "fundings" do
    field :create, :utc_datetime
    field :description, :string
    field :name, :string
    field :unit, :string
    field :valid, :boolean, default: false
    field :days, :integer
    field :validate, :integer

    has_many :projects, Project

    timestamps()
  end

  @doc false
  def changeset(%Funding{} = funding, attrs) do
    funding
    |> cast(attrs, [:name, :description, :unit, :days, :validate])
    |> validate_required([:name, :description, :unit, :days, :validate])
  end
end
