defmodule Homer.Repo.Migrations.CreateSteps do
  use Ecto.Migration

  def change do
    create table(:steps) do
      add :create_at, :utc_datetime
      add :project_id, references(:projects, on_delete: :nothing)
      add :step_template_id, references(:step_templates, on_delete: :nothing)

      timestamps()
    end

    create index(:steps, [:project_id])
    create index(:steps, [:step_template_id])
  end
end
