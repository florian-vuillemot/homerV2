defmodule Homer.Repo.Migrations.AddNameOnProject do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :name, :string
    end

    create unique_index(:projects, [:name])
  end
end
