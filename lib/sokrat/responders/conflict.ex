defmodule Sokrat.Responders.Conflict do
  @moduledoc false

  alias Sokrat.{Repo, Models.ConflictUser}
  use Hedwig.Responder

  @usage """
  hedwig conf status - Show current status (whether you'd like to receive notifications or not).
  """
  respond ~r/conf\sstatus$/i, msg do
    case find_user(msg) do
      {:ok, user} -> answer({:ok, :status}, msg, user)
      {:error, :not_found} -> answer({:error, :not_found}, msg)
    end
  end

  @usage """
  hedwig conf on - Enable conflict notifications.
  """
  respond ~r/conf\son$/i, msg do
    with {:ok, user} <- find_user(msg),
         {:ok, user} <- enable_user(user) do
      answer({:ok, :status}, msg, user)
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
      answer({:ok, :status}, msg, user)
    else
      {:error, reason} -> answer({:error, reason}, msg)
    end
  end

  @usage """
  hedwig conf me <bitbucket_username> - Add youself to conflicts notification list.
  """
  respond ~r/conf\sme\s(?<bitbucket_username>.+)$/i, msg do
    user = %ConflictUser{
      bitbucket_username: msg.matches["bitbucket_username"],
      slack_username: msg.user.name
    }

    case enable_user(user) do
      {:ok, user} ->
        answer({:ok, :status}, msg, user)
      {:error, %Ecto.Changeset{errors: errors}} ->
        answer({:error, :invalid}, msg, errors)
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
  defp answer({:error, :invalid}, msg, errors) do
    response = for {key, {message, _}} <- errors do
      "#{key} #{message}"
    end
    |> Enum.join("\n")

    send(msg, response)
  end
  defp answer({:ok, :status}, msg, user) do
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
    ConflictUser.changeset(user, params) |> Repo.insert_or_update
  end
end
