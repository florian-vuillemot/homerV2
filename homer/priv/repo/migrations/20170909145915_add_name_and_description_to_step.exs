defmodule Homer.Repo.Migrations.AddNameAndDescriptionToStep do
  use Ecto.Migration

  def change do
    alter table(:steps) do
      add :name, :string
      add :description, :string
    end
  end
end
