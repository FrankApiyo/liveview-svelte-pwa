defmodule LiveViewSvelteOfflineDemoWeb.PageLiveTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  feature "renders JavaScript content", %{session: session} do
    session
    |> visit("/")
    |> take_screenshot(name: "home_page_before_scroll")
    |> Wallaby.Browser.page_source()

    assert_has(session, Wallaby.Query.text("Local-first Mental Health Journaling"))

    assert_has(
      session,
      Wallaby.Query.text("This Journaling app is a demo of an installable")
    )

    assert_has(
      session,
      Wallaby.Query.text("PWA")
    )

    assert_has(
      session,
      Wallaby.Query.css(
        "a[href='https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps']"
      )
    )

    session
    |> Wallaby.Browser.execute_script(
      "document.querySelector('a[href=\"mailto:franklineapiyo@gmail.com\"]').scrollIntoView();"
    )
    # Capture after scrolling
    |> take_screenshot(name: "home_page_after_scroll")
  end
end
