defmodule Homer.Repo.Migrations.CreateFunders do
  use Ecto.Migration

  def change do
    create table(:funders) do
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :project_id, references(:projects, on_delete: :nothing)

      timestamps()
    end

    create index(:funders, [:user_id])
    create index(:funders, [:project_id])
  end
end
