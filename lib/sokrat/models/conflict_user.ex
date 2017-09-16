defmodule Sokrat.Models.ConflictUser do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset, only: [cast: 3, validate_required: 2, unique_constraint: 2]

  schema "conflict_users" do
    field :bitbucket_username, :string
    field :slack_username, :string
    field :enabled, :boolean
  end

  @required_fields [:bitbucket_username, :slack_username]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:enabled | @required_fields])
    |> unique_constraint(:bitbucket_username)
    |> unique_constraint(:slack_username)
    |> validate_required(@required_fields)
  end
end
