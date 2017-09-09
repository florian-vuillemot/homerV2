defmodule Homer.Repo.Migrations.UpdateRelationProjectAndFunding do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      remove :funding_id
      add :funding_id, references(:fundings, on_delete: :delete_all)
    end
  end
end
