defmodule Sokrat.Responders.RC do
  @moduledoc """
  Lists latest branches deployed on rc servers.
  """

  alias Sokrat.{Repo, Slack, Models}
  import Ecto.Query, only: [from: 2, join: 5, order_by: 3]
  use Hedwig.Responder
  use Timex

  @usage """
  hedwig rc - Shows latest deployed branches.
  """
  respond ~r/rc$/i, msg do
    Repo.all(Models.Application)
    |> Enum.each(&send_revisions(&1, msg.room))
  end

  @usage """
  hedwig rc <app> - Shows latest deployed branches for particular <app>.
                    Available options are: rails, php, js.
  """
  respond ~r/rc\s(?<app>[a-z]*)$/i, msg do
    key = msg.matches["app"]
    Repo.all(from a in Models.Application, where: a.key == ^key)
    |> Enum.each(&send_revisions(&1, msg.room))
  end

  defp send_revisions(app, room) do
    revisions = revisions_list(app)
    Keyword.merge(message_opts(app, revisions), [channel: room])
    |> Slack.chat_message
  end

  defp revisions_list(app) do
    Models.Revision
    |> join(:inner_lateral, [r], l in fragment("select t.id from revisions t where t.application_id = ? and t.server = ? order by deployed_at desc limit 1", ^app.id, r.server), r.id == l.id)
    |> order_by([r], [asc: r.server])
    |> Repo.all
  end

  defp message_opts(app, []) do
    attachments = [
      %{
        "color": "warning",
        "pretext": app.name,
        "text": "No revisions"
      }
    ]
    [attachments: Poison.encode!(attachments)]
  end

  defp message_opts(app, revisions) do
    attachments = [
      %{
        "color": "good",
        "pretext": app.name,
        "fields": Enum.map(revisions, &revision_info/1)
      }
    ]
    [attachments: Poison.encode!(attachments)]
  end

  defp revision_info(revision) do
    deployed_at = revision.deployed_at
    |> Timex.shift(hours: 3)
    |> Timex.format!("%Y-%m-%d %H:%M", :strftime)

    %{
      "title": revision.server,
      "value": "#{revision.branch}\n #{deployed_at}",
      "short": true
    }
  end
end
