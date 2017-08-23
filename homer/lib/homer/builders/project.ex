defmodule Homer.Builders.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.Builders.Project


  schema "projects" do
    field :create_at, :utc_datetime
    field :description, :string
    field :status, :integer
    field :to_raise, :integer
    field :funding_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Project{} = project, attrs) do
    project
    |> cast(attrs, [:description, :to_raise, :create_at, :status])
    |> validate_required([:description, :to_raise, :create_at, :status])
  end
end
