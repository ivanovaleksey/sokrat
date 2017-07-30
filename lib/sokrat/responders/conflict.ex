defmodule Sokrat.Responders.Conflict do
  @moduledoc false

  alias Sokrat.{Repo, Models.ConflictUser}
  use Hedwig.Responder

  @usage """
  hedwig conf status - Show current status (whether you'd like to receive notifications or not).
  """
  respond ~r/conf\sstatus$/i, msg do
    find_user(msg)
    |> reply_to_user(msg)
  end

  @usage """
  hedwig conf on - Enable conflict notifications.
  """
  respond ~r/conf\son$/i, msg do
    find_user(msg)
    |> enable_user
    |> reply_to_user(msg)
  end

  @usage """
  hedwig conf off - Disable conflict notifications.
  """
  respond ~r/conf\soff$/i, msg do
    find_user(msg)
    |> disable_user
    |> reply_to_user(msg)
  end

  defp find_user(msg) do
    Repo.get_by(ConflictUser, slack_username: msg.user.name)
  end

  defp reply_to_user(nil, msg) do
    send(msg, "You are not in the list. Please contact administrator.")
  end

  defp reply_to_user(user, msg) do
    if user.enabled do
      send(msg, "Conflict notifications are enabled")
    else
      send(msg, "Conflict notifications are disabled")
    end
  end

  defp enable_user(nil), do: nil
  defp enable_user(user) do
    update_user(user, %{enabled: true})
  end

  defp disable_user(nil), do: nil
  defp disable_user(user) do
    update_user(user, %{enabled: false})
  end

  defp update_user(user, params) do
    ConflictUser.changeset(user, params) |> Repo.update!
  end
end
