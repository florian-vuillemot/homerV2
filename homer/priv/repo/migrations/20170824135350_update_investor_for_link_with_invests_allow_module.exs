defmodule Homer.Repo.Migrations.UpdateInvestorForLinkWithInvestsAllowModule do
  use Ecto.Migration

  def change do
    alter table(:investors) do
      remove :funding
      add :invest_allow_id, references(:invests_allows, on_delete: :nothing)
    end

    create index(:investors, [:invest_allow_id])
  end
end
