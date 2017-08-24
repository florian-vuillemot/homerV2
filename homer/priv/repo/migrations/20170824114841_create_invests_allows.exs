defmodule Homer.Repo.Migrations.CreateInvestsAllows do
  use Ecto.Migration

  def change do
    create table(:invests_allows) do
      add :name, :string
      add :description, :string
      add :invest, :integer
      add :funding_id, references(:fundings, on_delete: :nothing)

      timestamps()
    end

    create index(:invests_allows, [:funding_id])
  end
end
