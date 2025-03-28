defmodule LiveViewSvelteOfflineDemo.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveViewSvelteOfflineDemo.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "HHello world!2"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> LiveViewSvelteOfflineDemo.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]") |> IO.inspect()
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
