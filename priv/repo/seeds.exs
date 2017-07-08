defmodule Sokrat.Seeder do
  alias Sokrat.{Repo, Models}

  def applications do
    Repo.insert_all(Models.Application, [
      [key: "rails", name: "Ruby on Rails"],
      [key: "php",   name: "PHP"],
      [key: "front", name: "Front"]
    ])
  end
end

Sokrat.Seeder.applications()
