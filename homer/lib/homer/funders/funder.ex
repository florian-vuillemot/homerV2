defmodule Homer.Funders.Funder do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.Funders.Funder

  alias Homer.Accounts.User
  alias Homer.Builders.Project

  schema "funders" do
    field :status, :string

    belongs_to :user, User
    belongs_to :project, Project

    timestamps()
  end

  @doc false
  def changeset(%Funder{} = funder, attrs) do
    funder
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end
