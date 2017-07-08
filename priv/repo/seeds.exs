defmodule Sokrat.Seeder do
  alias Sokrat.{Repo, Models}

  def applications do
    Repo.insert_all(Models.Application, [
      [key: "rails", name: "Ruby on Rails"],
      [key: "php",   name: "PHP"],
      [key: "front", name: "Front"]
    ])
  end

  def revisions do
    rails_app = Repo.get_by!(Models.Application, key: "rails")
    Repo.insert_all(Models.Revision, [
      [application_id: rails_app.id, server: "rc1", branch: "feature/1", revision: "ahs213c", deployed_at: NaiveDateTime.utc_now],
      [application_id: rails_app.id, server: "rc1", branch: "feature/2", revision: "ahs213c", deployed_at: NaiveDateTime.utc_now],
      [application_id: rails_app.id, server: "rc2", branch: "feature/3", revision: "ahs213c", deployed_at: NaiveDateTime.utc_now]
    ])

    php_app = Repo.get_by!(Models.Application, key: "php")
    Repo.insert_all(Models.Revision, [
      [application_id: php_app.id, server: "rc1", branch: "feature/10", revision: "ahs213c", deployed_at: NaiveDateTime.utc_now],
      [application_id: php_app.id, server: "rc2", branch: "feature/20", revision: "ahs213c", deployed_at: NaiveDateTime.utc_now],
      [application_id: php_app.id, server: "rc2", branch: "feature/30", revision: "ahs213c", deployed_at: NaiveDateTime.utc_now]
    ])
  end
end

Sokrat.Seeder.applications()
Sokrat.Seeder.revisions()
