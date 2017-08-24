defmodule Homer.Repo.Migrations.AddDatetimeFieldInvestsAllows do
  use Ecto.Migration

  def change do
    alter table(:invests_allows) do
      add :create_at, :utc_datetime
    end
  end
end
