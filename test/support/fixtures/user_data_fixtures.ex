defmodule LiveViewSvelteOfflineDemo.UserDataFixtures do
  alias LiveViewSvelteOfflineDemo.AccountsFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveViewSvelteOfflineDemo.UserData` context.
  """

  @doc """
  Generate a user_document.
  """
  def user_document_fixture(attrs \\ %{}) do
    {:ok, user_document} =
      attrs
      |> Map.merge(%{:user_id => AccountsFixtures.user_fixture().id}, fn _key, v1, _v2 -> v1 end)
      |> Enum.into(%{
        document:
          "AVvyu7CnDgAnAQAIam91cm5hbHMABwDyu7CnDgABKADyu7CnDgECaWQBdyRhMWU1NDcyZC1lMmY2LTQxNTctODA1Ny0yOTE0MTY2NDhiODchAPK7sKcOAQRuYW1lAScA8ruwpw4BBGJvZHkCofK7sKcOAwIBAPK7sKcOBAGh8ruwpw4GAYHyu7CnDgcBofK7sKcOCAGB8ruwpw4JAaHyu7CnDgoEhPK7sKcOCwFPofK7sKcODwGE8ruwpw4QAW6h8ruwpw4RAYTyu7CnDhIBZaHyu7CnDhMBhPK7sKcOFAEgofK7sKcOFQGE8ruwpw4WAXSh8ruwpw4XAYTyu7CnDhgBd6Hyu7CnDhkBhPK7sKcOGgFvofK7sKcOGwGE8ruwpw4cASCh8ruwpw4dAYTyu7CnDh4BdKHyu7CnDh8BhPK7sKcOIAFoofK7sKcOIQGE8ruwpw4iAXKh8ruwpw4jAYTyu7CnDiQBZaHyu7CnDiUBhPK7sKcOJgFlofK7sKcOJwGE8ruwpw4oASCh8ruwpw4pAYTyu7CnDioBZqHyu7CnDisBhPK7sKcOLAFvofK7sKcOLQGE8ruwpw4uAXWh8ruwpw4vAYTyu7CnDjABcqHyu7CnDjEBhPK7sKcOMgEgofK7sKcOMwGE8ruwpw40AWah8ruwpw41AYTyu7CnDjYBaaHyu7CnDjcBhPK7sKcOOAF2ofK7sKcOOQGE8ruwpw46AWWh8ruwpw47AYTyu7CnDjwBIKHyu7CnDj0BhPK7sKcOPgFzofK7sKcOPwGE8ruwpw5AAWmh8ruwpw5BAYTyu7CnDkIBeKHyu7CnDkMBhPK7sKcORAEgofK7sKcORQGE8ruwpw5GAXOh8ruwpw5HAYTyu7CnDkgBZaHyu7CnDkkBhPK7sKcOSgF2ofK7sKcOSwGE8ruwpw5MAWWh8ruwpw5NAYTyu7CnDk4BbqHyu7CnDk8BhPK7sKcOUAEgofK7sKcOUQGE8ruwpw5SATih8ruwpw5TAYTyu7CnDlQBIKHyu7CnDlUBhPK7sKcOVgE5ofK7sKcOVwGE8ruwpw5YASCh8ruwpw5ZAYTyu7CnDloBMqjyu7CnDlsBdwNvbmWE8ruwpw5cATAB8ruwpw4oAwEFCxEBEwEVARcBGQEbAR0BHwEhASMBJQEnASkBKwEtAS8BMQEzATUBNwE5ATsBPQE/AUEBQwFFAUcBSQFLAU0BTwFRAVMBVQFXAVkBWwE="
      })
      |> LiveViewSvelteOfflineDemo.UserData.create_user_document()

    user_document
  end
end
