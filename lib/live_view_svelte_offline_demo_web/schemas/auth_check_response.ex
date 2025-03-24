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
        role: %OpenApiSpex.Schema{type: :string, example: "defualt"},
        message: %OpenApiSpex.Schema{type: :string, example: "OK"},
        user_id: %OpenApiSpex.Schema{type: :integer, example: 1}
      },
      required: [:message, :user_id]
    }
  end
end
