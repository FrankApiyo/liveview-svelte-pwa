defmodule LiveViewSvelteOfflineDemoWeb.UserDataController do
  use LiveViewSvelteOfflineDemoWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias LiveViewSvelteOfflineDemo.UserData
  alias Guardian.Plug
  alias LiveViewSvelteOfflineDemoWeb.Schemas.UserDocument

  tags(["documents"])

  operation(:user_documents,
    summary: "Get user documents",
    description: "Retrieves a list of documents associated with the authenticated user",
    security: [%{"apiKeyAuth" => []}, %{"jwtAuth" => []}],
    responses: %{
      200 => {"List of user documents", "application/json", UserDocument.DocumentList},
      401 =>
        {"Unauthorized", "application/json",
         LiveViewSvelteOfflineDemoWeb.Schemas.UnauthorizedError}
    }
  )

  def user_documents(conn, _params) do
    user = Plug.current_resource(conn)

    case user do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Unauthorized"})

      _ ->
        documents = UserData.get_user_ex_document_by_user_id(user.id)
        json(conn, %{documents: documents})
    end
  end

  operation(:auth_check,
    summary: "Authentication Check",
    description: "Returns OK if the request is authenticated",
    security: [%{"apiKeyAuth" => []}, %{"jwtAuth" => []}],
    responses: %{
      200 =>
        {"Success", "application/json", LiveViewSvelteOfflineDemoWeb.Schemas.AuthCheckResponse},
      401 =>
        {"Unauthorized", "application/json",
         LiveViewSvelteOfflineDemoWeb.Schemas.UnauthorizedError}
    }
  )

  def auth_check(conn, _params) do
    user = Plug.current_resource(conn)

    case user do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Unauthorized"})

      user ->
        json(conn, %{message: "OK", user_id: user.id})
    end
  end
end
