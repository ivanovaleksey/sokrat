defmodule Sokrat.Repo.Migrations.CreateApplications do
  use Ecto.Migration

  def change do
    create table(:applications) do
      add :key, :string
      add :name, :string
    end
    create index(:applications, :key, unique: true)
  end
end
