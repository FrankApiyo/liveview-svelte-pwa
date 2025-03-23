defmodule LiveViewSvelteOfflineDemo.Guardian do
  use Guardian, otp_app: :live_view_svelte_offline_demo

  alias LiveViewSvelteOfflineDemo.Accounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user(id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
