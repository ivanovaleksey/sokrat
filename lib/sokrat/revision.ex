defmodule Sokrat.Revision do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "revisions" do
    field :project, :string
    field :server, :string
    field :branch, :string
    field :revision, :string
    field :deployed_at, :naive_datetime
  end

  def changeset(struct, params \\ %{}) do
    attributes = ~w[project server branch revision deployed_at]
    attributes = for attr <- attributes, do: String.to_atom(attr)
    struct
    |> cast(params, attributes)
    |> validate_required(attributes)
  end
end
