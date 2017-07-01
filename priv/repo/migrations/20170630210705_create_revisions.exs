defmodule Sokrat.Repo.Migrations.CreateRevisions do
  use Ecto.Migration

  def change do
    create table(:revisions) do
      add :server, :string
      add :branch, :string
      add :revision, :string
      add :deployed_at, :naive_datetime
    end
  end
end
