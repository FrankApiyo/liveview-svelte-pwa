defmodule LiveViewSvelteOfflineDemoWeb.Router do
  use LiveViewSvelteOfflineDemoWeb, :router

  import LiveViewSvelteOfflineDemoWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LiveViewSvelteOfflineDemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :openapi_spec do
    plug OpenApiSpex.Plug.PutApiSpec, module: LiveViewSvelteOfflineDemoWeb.ApiSpec
  end

  pipeline :x_api_auth do
    plug LiveViewSvelteOfflineDemoWeb.Plugs.RequireSignupToken
  end

  pipeline :api_auth do
    plug Guardian.Plug.Pipeline,
      module: LiveViewSvelteOfflineDemo.Guardian,
      error_handler: LiveViewSvelteOfflineDemoWeb.AuthErrorHandler

    plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", LiveViewSvelteOfflineDemoWeb do
    pipe_through :api

    scope "/" do
      pipe_through :x_api_auth
      post "/signup", AuthController, :signup
      post "/login", AuthController, :login
    end

    scope "/" do
      pipe_through :api_auth
      pipe_through :x_api_auth

      get "/user_documents", UserDataController, :user_documents
      get "/auth_check", UserDataController, :auth_check
    end
  end

  scope "/" do
    pipe_through :browser

    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/openapi"
  end

  scope "/" do
    pipe_through :openapi_spec
    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/", LiveViewSvelteOfflineDemoWeb do
    pipe_through :browser

    # This route is just for creating the logo image in development.
    # get "/logo", LogoController, :index

    # This route is for demonstrating the use of LiveSvelte + LiveView in the
    # Working in Elevators presentation.
    # live "/live_svelte", ExampleLive

    get "/offline", OfflineController, :index
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:live_view_svelte_offline_demo, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LiveViewSvelteOfflineDemoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", LiveViewSvelteOfflineDemoWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{LiveViewSvelteOfflineDemoWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    get "/", HomeController, :index
    post "/users/log_in", UserSessionController, :create
  end

  scope "/", LiveViewSvelteOfflineDemoWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{LiveViewSvelteOfflineDemoWeb.UserAuth, :ensure_authenticated}] do
      live "/users/dataViz", DataVizLive
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end

    get "/app", AppController, :index
  end

  scope "/", LiveViewSvelteOfflineDemoWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{LiveViewSvelteOfflineDemoWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  if Mix.env() == :test do
    scope "/test" do
      get "/trigger-internal-server-error",
          IntentionalError.TestErrorController,
          :error
    end
  end
end
