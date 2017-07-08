defmodule Sokrat.Router do
  alias Sokrat.{Repo, Models.Application, Models.Revision}
  import Ecto.Query, only: [select: 3]
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass: ["application/json"],
                     json_decoder: Poison
  plug :set_resp_content_type
  plug :dispatch


  get "/applications" do
    apps = Application |> select([a], map(a, [:id, :key, :name])) |> Repo.all
    send_resp(conn, 200, Poison.encode!(apps))
  end

  post "/applications" do
    params = conn.body_params

    {status, changeset} = create_application(params)
    respond(conn, status, changeset)
  end

  post "/applications/:app_key/revisions" do
    params = conn.body_params

    app = Repo.get_by!(Application, key: app_key)
    {status, changeset} = create_revision(app, params)
    respond(conn, status, changeset)
  end

  match _ do
    send_resp(conn, 404, "")
  end

  defp create_application(params) do
    changeset = Application.changeset(%Application{}, params)
    Repo.insert(changeset)
  end

  defp create_revision(application, params) do
    revision = Ecto.build_assoc(application, :revisions, deployed_at: NaiveDateTime.utc_now)
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

  defp set_resp_content_type(conn, _opts) do
    put_resp_content_type(conn, "application/json")
  end
end
