defmodule LiveViewSvelteOfflineDemoWeb.Schemas.UserDocument do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  @moduledoc """
  Schema for a user document.
  """
  defmodule Document do
    OpenApiSpex.schema(%{
      title: "User Document",
      description: "A document associated with a user",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid, description: "Document ID"},
        name: %Schema{type: :string, description: "Document name"},
        body: %Schema{type: :string, description: "Document content"}
      },
      required: [:id, :name, :body]
    })
  end

  defmodule DocumentList do
    OpenApiSpex.schema(%{
      title: "User Documents",
      description: "A list of user documents",
      type: :object,
      properties: %{
        documents: %Schema{type: :array, items: Document}
      },
      required: [:documents]
    })
  end
end
