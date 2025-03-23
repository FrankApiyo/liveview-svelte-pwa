defmodule LiveViewSvelteOfflineDemoWeb.Schemas.AuthCheckResponse do
  require OpenApiSpex

  @behaviour OpenApiSpex.Schema

  @impl OpenApiSpex.Schema
  def schema do
    %OpenApiSpex.Schema{
      title: "AuthCheckResponse",
      description: "Response schema for the auth check endpoint",
      type: :object,
      properties: %{
        message: %OpenApiSpex.Schema{type: :string, example: "OK"}
      },
      required: [:message]
    }
  end
end
