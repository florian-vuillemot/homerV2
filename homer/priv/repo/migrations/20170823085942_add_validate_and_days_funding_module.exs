defmodule Homer.Repo.Migrations.AddValidateAndDaysFundingModule do
  use Ecto.Migration

  def change do
    alter table(:fundings) do
      add :days, :integer
      add :validate, :integer
    end
  end
end
