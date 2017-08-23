defmodule Homer.Repo.Migrations.CreateInvestors do
  use Ecto.Migration

  def change do
    create table(:investors) do
      add :funding, :integer
      add :comment, :string
      add :project_id, references(:projects, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:investors, [:project_id])
    create index(:investors, [:user_id])
  end
end
