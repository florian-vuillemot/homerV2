defmodule Homer.Repo.Migrations.RemoveCreateAtOnInvestAllow do
  use Ecto.Migration

  def change do
    alter table(:invests_allows) do
      remove :create_at
    end
  end
end
