defmodule Sokrat.Models.Application do
  @moduledoc false

  alias Sokrat.Models.Revision
  use Ecto.Schema
  import Ecto.Changeset, only: [cast: 3, validate_required: 2, unique_constraint: 2]

  schema "applications" do
    field :key, :string
    field :name, :string

    has_many :revisions, Revision
  end

  @required_fields [:key, :name]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:key)
  end
end
