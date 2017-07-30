defmodule Sokrat.Repo.Migrations.CreateConflictUsers do
  use Ecto.Migration

  def change do
    create table(:conflict_users) do
      add :bitbucket_username, :string
      add :slack_username, :string
      add :enabled, :boolean, null: false, default: true
    end
  end
end
