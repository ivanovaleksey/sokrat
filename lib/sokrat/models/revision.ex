defmodule Sokrat.Models.Revision do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

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
    |> cast(params, attributes)
    |> validate_required([:deployed_at | attributes])
  end
end
