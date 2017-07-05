defmodule Sokrat.Repo.Migrations.AddProjectToRevisions do
  use Ecto.Migration

  def change do
    alter table(:revisions) do
      add :project, :string
    end
  end
end
