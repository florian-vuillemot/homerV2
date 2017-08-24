defmodule Homer.Repo.Migrations.CreateStepsValidation do
  use Ecto.Migration

  def change do
    create table(:steps_validation) do
      add :valid, :integer
      add :comment, :string
      add :step_id, references(:steps, on_delete: :nothing)
      add :investor_id, references(:investors, on_delete: :nothing)

      timestamps()
    end

    create index(:steps_validation, [:step_id])
    create index(:steps_validation, [:investor_id])
  end
end
