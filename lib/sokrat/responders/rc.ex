defmodule Sokrat.Responders.RC do
  @moduledoc """
  Lists latest branches deployed on rc servers.
  """

  alias Sokrat.{Repo, Models, Decorators}
  use Hedwig.Responder
  import Ecto.Query, only: [join: 5, order_by: 3]

  @usage """
  hedwig: rc - Lists latest branches deployed on rc servers.
  """
  respond ~r/rc$/i, msg do
    send msg, Decorators.Revision.list(revisions_list())
  end

  defp revisions_list do
    Models.Revision
    |> join(:inner_lateral, [r], l in fragment("select t.id from revisions t where t.server = ? order by deployed_at desc limit 1", r.server), r.id == l.id)
    |> order_by([r], [asc: r.server])
    |> Repo.all
  end
end
