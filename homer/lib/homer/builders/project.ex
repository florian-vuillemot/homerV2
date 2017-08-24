defmodule Homer.Builders.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.Builders.Project

  alias Homer.Monetizations.Funding
  alias Homer.Invests.Investor
  alias Homer.Funders.Funder
  alias Homer.Steps.Step

  schema "projects" do
    field :name, :string
    field :create_at, :utc_datetime
    field :description, :string
    field :status, :string
    field :to_raise, :integer
    field :github, :string

    #field :funding_id, :id
    belongs_to :funding, Funding
    has_many :investors, Investor
    has_many :funders, Funder
    has_many :steps, Step

    timestamps()
  end

  @doc false
  def changeset(%Project{} = project, attrs) do
    project
    |> cast(attrs, [:name, :description, :to_raise, :github])
    |> validate_required([:name, :description, :to_raise])
    |> unique_constraint(:name)
  end
end
