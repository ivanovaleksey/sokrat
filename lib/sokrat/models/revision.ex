defmodule Sokrat.Models.Revision do
  @moduledoc false

  alias Sokrat.Models.Application
  use Ecto.Schema
  import Ecto.Changeset, only: [cast: 3, validate_required: 2]

  schema "revisions" do
    field :server, :string
    field :branch, :string
    field :revision, :string
    field :deployed_at, :naive_datetime

    belongs_to :application, Application
  end

  @required_fields [:server, :branch, :revision]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required([:deployed_at | @required_fields])
  end
end
