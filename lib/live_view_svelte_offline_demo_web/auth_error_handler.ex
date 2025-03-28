defmodule LiveViewSvelteOfflineDemoWeb.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {_type, reason}, _opts) do
    body = Jason.encode!(%{error: to_string(reason)})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
