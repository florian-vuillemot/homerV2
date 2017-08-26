defmodule Homer.Repo.Migrations.UpdateRelationFunding do
  use Ecto.Migration

  def change do
    alter table(:invests_allows) do
      remove :funding_id
      add :funding_id, references(:fundings, on_delete: :delete_all)
    end

    alter table(:projects) do
      remove :funding_id
      add :funding_id, references(:fundings, on_delete: :nothing)
    end

    alter table(:step_templates) do
      remove :funding_id
      add :funding_id, references(:fundings, on_delete: :delete_all)
    end
  end
end
