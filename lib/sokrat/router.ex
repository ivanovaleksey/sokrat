defmodule Sokrat.Router do
  alias Sokrat.{Repo, Revision}
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass: ["application/json"],
                     json_decoder: Poison
  plug :dispatch

  post "/hello" do
    conn = put_resp_content_type(conn, "application/json")
    params = conn.body_params

    {status, changeset} = create_revision(params)
    respond(conn, status, changeset)
  end

  match _ do
    send_resp(conn, 404, "")
  end

  defp create_revision(params) do
    revision = %Revision{deployed_at: NaiveDateTime.utc_now}
    changeset = Revision.changeset(revision, params)
    Repo.insert(changeset)
  end

  defp respond(conn, :ok, _) do
    send_resp(conn, 201, "")
  end

  defp respond(conn, :error, changeset) do
    errors = for {field, {message, _}} <- changeset.errors, into: %{}, do: {field, message}
    send_resp(conn, 422, Poison.encode!(%{errors: errors}))
  end
end
