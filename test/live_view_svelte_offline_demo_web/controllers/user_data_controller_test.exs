defmodule LiveViewSvelteOfflineDemoWeb.UserDataControllerTest do
  use LiveViewSvelteOfflineDemoWeb.ConnCase, async: true

  import LiveViewSvelteOfflineDemo.AccountsFixtures
  import LiveViewSvelteOfflineDemo.UserDataFixtures

  alias LiveViewSvelteOfflineDemo.Guardian

  @api_key Application.compile_env!(:live_view_svelte_offline_demo, :api_auth)[:signup_token]

  setup %{conn: conn} do
    conn = put_req_header(conn, "x-api-key", @api_key)
    {:ok, conn: conn}
  end

  setup do
    # Create a user
    user = user_fixture()

    # Create a user document associated with the user
    document = user_document_fixture(%{user_id: user.id})

    %{user: user, document: document}
  end

  describe "GET /api/user_documents" do
    test "returns user documents when authenticated", %{
      conn: conn,
      user: user,
      document: _document
    } do
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      response = get(conn, ~p"/api/user_documents")

      assert json_response(response, 200)["documents"] == [
               %{
                 "id" => "4347f1ea-582a-4637-8525-6f5f9af5bc7e",
                 "body" => "Hey, how are you? How did you sleep? Are you ok?",
                 "name" => "Good morning journal!"
               }
             ]
    end

    test "returns 401 when user is not authenticated", %{conn: conn} do
      response = get(conn, ~p"/api/user_documents")

      assert response.status == 401
      assert json_response(response, 401) == %{"error" => "no_resource_found"}
    end
  end

  describe "GET /api/auth_check" do
    test "returns OK when authenticated", %{conn: conn, user: user} do
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      response = get(conn, ~p"/api/auth_check")

      assert response.status == 200

      assert json_response(response, 200) == %{
               "message" => "OK",
               "user_id" => user.id,
               "role" => "default"
             }
    end

    test "returns 401 when user is not authenticated", %{conn: conn} do
      response = get(conn, ~p"/api/auth_check")

      assert response.status == 401
      assert json_response(response, 401) == %{"error" => "no_resource_found"}
    end
  end
end
