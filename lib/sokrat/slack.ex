defmodule Sokrat.Slack do
  @moduledoc false

  @url "https://slack.com"

  def chat_message(args \\ []) do
    args = Keyword.merge(params(), args)
    HTTPoison.post!("#{@url}/api/chat.postMessage", {:form, args})
  end

  defp params do
    channel = Application.get_env(:sokrat, :slack).channel
    token   = Application.get_env(:sokrat, :slack).token

    [channel: channel,
     token: token,
     as_user: true]
  end
end
