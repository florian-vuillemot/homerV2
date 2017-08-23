defmodule Homer.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :description, :string
      add :to_raise, :integer
      add :create_at, :utc_datetime
      add :status, :integer
      add :funding_id, references(:fundings, on_delete: :nothing)

      timestamps()
    end

    create index(:projects, [:funding_id])
  end
end
