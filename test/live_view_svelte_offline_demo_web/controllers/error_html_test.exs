defmodule LiveViewSvelteOfflineDemoWeb.ErrorPageTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  feature "renders 404 page", %{session: session} do
    session
    |> visit("/non-existent-page")
    |> take_screenshot(name: "page_not_found")

    assert_has(session, Wallaby.Query.text("Whoops, page not found..."))
  end

  feature "renders 500 page", %{session: session} do
    session
    |> visit("/test/trigger-internal-server-error")
    |> take_screenshot(name: "internal_server_error")

    assert_has(session, Wallaby.Query.text("Whoops, an unknown error has occurred..."))
  end
end
