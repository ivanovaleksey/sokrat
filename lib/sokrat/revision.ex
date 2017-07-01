defmodule Sokrat.Revision do
  use Ecto.Schema

  schema "revisions" do
    field :server, :string
    field :branch, :string
    field :revision, :string
    field :deployed_at, :naive_datetime
  end

  def changeset(struct, params \\ %{}) do
    attributes = ~w[server branch revision]
    attributes = for attr <- attributes, do: String.to_atom(attr)
    struct
    |> Ecto.Changeset.cast(params, attributes)
    |> Ecto.Changeset.validate_required([:deployed_at | attributes])
  end
end
