defmodule Homer.Builders.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homer.Builders.Project


  schema "projects" do
    field :name, string
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
    |> cast(attrs, [:name, :description, :to_raise, :create_at, :status])
    |> validate_required([:name, :description, :to_raise, :create_at, :status])
    |> unique_constraint(:name)
  end
end
