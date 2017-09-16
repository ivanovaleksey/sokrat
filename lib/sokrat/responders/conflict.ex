defmodule Sokrat.Responders.Conflict do
  @moduledoc false

  alias Sokrat.{Repo, Models.ConflictUser}
  use Hedwig.Responder

  @usage """
  hedwig conf status - Show current status (whether you'd like to receive notifications or not).
  """
  respond ~r/conf\sstatus$/i, msg do
    case find_user(msg) do
      {:ok, user} -> answer({:ok, :status}, user, msg)
      {:error, :not_found} -> answer({:error, :not_found}, msg)
    end
  end

  @usage """
  hedwig conf on - Enable conflict notifications.
  """
  respond ~r/conf\son$/i, msg do
    with {:ok, user} <- find_user(msg),
         {:ok, user} <- enable_user(user) do
      answer({:ok, :status}, user, msg)
    else
      {:error, reason} -> answer({:error, reason}, msg)
    end
  end

  @usage """
  hedwig conf off - Disable conflict notifications.
  """
  respond ~r/conf\soff$/i, msg do
    with {:ok, user} <- find_user(msg),
         {:ok, user} <- disable_user(user) do
      answer({:ok, :status}, user, msg)
    else
      {:error, reason} -> answer({:error, reason}, msg)
    end
  end

  defp find_user(msg) do
    Repo.get_by(ConflictUser, slack_username: msg.user.name)
    |> case do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  defp answer({:error, :not_found}, msg) do
    send(msg, "You are not in the list. Please contact administrator.")
  end
  defp answer({:error, _}, msg) do
    send(msg, "Something went wrong. Please contact administrator.")
  end
  defp answer({:ok, :status}, user, msg) do
    if user.enabled do
      send(msg, "Conflict notifications are enabled")
    else
      send(msg, "Conflict notifications are disabled")
    end
  end

  defp enable_user(user) do
    update_user(user, %{enabled: true})
  end

  defp disable_user(user) do
    update_user(user, %{enabled: false})
  end

  defp update_user(user, params) do
    ConflictUser.changeset(user, params) |> Repo.update
  end
end
