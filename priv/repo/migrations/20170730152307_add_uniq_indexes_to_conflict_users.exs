defmodule Sokrat.Repo.Migrations.AddUniqIndexesToConflictUsers do
  use Ecto.Migration

  def change do
    create unique_index(:conflict_users, :bitbucket_username)
    create unique_index(:conflict_users, :slack_username)
  end
end
