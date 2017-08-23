defmodule Homer.Repo.Migrations.UpdateStatusTypeOnProject do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      modify :status, :string
    end
  end
end
