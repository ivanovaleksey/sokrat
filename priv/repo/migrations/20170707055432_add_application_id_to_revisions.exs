defmodule Sokrat.Repo.Migrations.AddApplicationIdToRevisions do
  use Ecto.Migration

  def change do
    alter table(:revisions) do
      add :application_id, :integer
    end
  end
end
