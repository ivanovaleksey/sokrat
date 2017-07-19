defmodule Sokrat.ReleaseTasks do
  @moduledoc false

  @start_apps [
    :postgrex,
    :ecto
  ]

  @myapps [
    :sokrat
  ]

  @repos [
    Sokrat.Repo
  ]

  def migrate do

  end

  defp run_migrations_for(app) do
    IO.puts "Running migrations for #{app}"
    Ecto.Migrator.run(MyApp.Repo, migrations_path(app), :up, all: true)
  end

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])
  defp seed_path(app), do: Path.join([priv_dir(app), "repo", "seeds.exs"])
end
