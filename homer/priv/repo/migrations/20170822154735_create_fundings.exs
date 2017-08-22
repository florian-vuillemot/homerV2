defmodule Homer.Repo.Migrations.CreateFundings do
  use Ecto.Migration

  def change do
    create table(:fundings) do
      add :name, :string
      add :description, :string
      add :unit, :string
      add :create, :utc_datetime
      add :valid, :boolean, default: false, null: false

      timestamps()
    end

  end
end
