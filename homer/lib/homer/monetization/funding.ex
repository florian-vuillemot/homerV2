defmodule Homer.Monetization.Funding do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.Monetization.Funding


  schema "fundings" do
    field :create, :utc_datetime
    field :description, :string
    field :name, :string
    field :unit, :string
    field :valid, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(%Funding{} = funding, attrs) do
    funding
    |> cast(attrs, [:name, :description, :unit])
    |> validate_required([:name, :description, :unit])
  end
end
