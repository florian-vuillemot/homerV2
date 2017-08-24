defmodule Homer.InvestsAllows.InvestAllow do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.InvestsAllows.InvestAllow

  alias Homer.Monetizations.Funding

  schema "invests_allows" do
    field :description, :string
    field :invest, :integer
    field :name, :string
    field :create_at, :utc_datetime

    #field :funding_id, :id
    belongs_to :funding, Funding

    timestamps()
  end

  @doc false
  def changeset(%InvestAllow{} = invest_allow, attrs) do
    invest_allow
    |> cast(attrs, [:name, :description, :invest])
    |> validate_required([:name, :description, :invest])
  end
end
