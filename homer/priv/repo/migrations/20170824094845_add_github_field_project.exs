defmodule Homer.Repo.Migrations.AddGithubFieldProject do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :github, :string, default: nil
    end
  end
end
