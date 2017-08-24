defmodule Homer.Repo.Migrations.CreateStepTemplates do
  use Ecto.Migration

  def change do
    create table(:step_templates) do
      add :name, :string
      add :description, :string
      add :rank, :integer
      add :funding_id, references(:fundings, on_delete: :nothing)

      timestamps()
    end

    create index(:step_templates, [:funding_id])
  end
end
