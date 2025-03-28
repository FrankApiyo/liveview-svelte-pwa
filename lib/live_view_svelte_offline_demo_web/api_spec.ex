defmodule LiveViewSvelteOfflineDemoWeb.ApiSpec do
  alias OpenApiSpex.{Components, SecurityScheme, Info, OpenApi, Paths, Server}
  alias LiveViewSvelteOfflineDemoWeb.{Endpoint, Router}

  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        # Populate the Server info from a Phoenix endpoint
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: to_string(Application.spec(:live_view_svelte_offline_demo, :description)),
        version: to_string(Application.spec(:live_view_svelte_offline_demo, :vsn))
      },
      # Populate the paths from a Phoenix router
      paths: Paths.from_router(Router),
      components: %Components{
        securitySchemes: %{
          "apiKeyAuth" => %SecurityScheme{
            type: "apiKey",
            in: "header",
            name: "x-api-key",
            description: """
            API key authentication required to create a user.
            - Include `x-api-key` in the request headers.
            - You must obtain this API key from the system administrator.
            """
          },
          "jwtAuth" => %SecurityScheme{
            type: "http",
            scheme: "bearer",
            bearerFormat: "JWT",
            description: """
            JWT-based authentication.
            - Pass the token in the `Authorization` header as `Bearer <token>`.
            - The token is obtained from the login endpoint.
            """
          }
        }
      },
      security: [%{"jwtAuth" => []}]
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
