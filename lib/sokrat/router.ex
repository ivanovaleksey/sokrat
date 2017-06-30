defmodule Sokrat.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass: ["application/json"],
                     json_decoder: Poison
  plug :dispatch

  post "/hello" do
    send_resp(conn, 200, "")
  end

  match _ do
    send_resp(conn, 404, "")
  end
end
