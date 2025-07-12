defmodule HeadsUpWeb.Router do
  use HeadsUpWeb, :router

  import HeadsUpWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HeadsUpWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :snoop
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HeadsUpWeb do
    pipe_through :browser

    get "/welcome", PageController, :home
    get "/tips", TipController, :index
    get "/tips/:id", TipController, :show

    live "/", IncidentLive.Index
    live "/effort", EffortLive
    live "/incidents", IncidentLive.Index
    live "/incidents/:id", IncidentLive.Show
  end

  # Admin section
  scope "/", HeadsUpWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :admin,
      on_mount: [{HeadsUpWeb.UserAuth, :ensure_authenticated}, {HeadsUpWeb.Hooks, :current_time}] do
      live "/admin/incidents", AdminIncidentLive.Index
      live "/admin/incidents/new", AdminIncidentLive.Form, :new
      live "/admin/incidents/:id/edit", AdminIncidentLive.Form, :edit

      live "/categories", CategoryLive.Index, :index
      live "/categories/new", CategoryLive.Form, :new
      live "/categories/:id", CategoryLive.Show, :show
      live "/categories/:id/edit", CategoryLive.Form, :edit
    end
  end

  def snoop(conn, _opts) do
    answer = ~w(Yes No Maybe) |> Enum.random()
    conn = assign(conn, :answer, answer)

    IO.inspect(conn, label: "Snoop")
    conn
  end

  # Other scopes may use custom stacks.
  scope "/api", HeadsUpWeb.Api do
    pipe_through :api

    get "/incidents", IncidentController, :index
    get "/incidents/:id", IncidentController, :show

    get "/categories/:id/incidents", CategoryController, :show

    post "/incidents", IncidentController, :create
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:heads_up, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HeadsUpWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", HeadsUpWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{HeadsUpWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/reset-password", UserLive.ForgotPassword, :new
      live "/users/reset-password/:token", UserLive.ResetPassword, :edit
    end

    post "/users/log-in", UserSessionController, :create
  end

  scope "/", HeadsUpWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{HeadsUpWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end
  end

  scope "/", HeadsUpWeb do
    pipe_through [:browser]

    delete "/users/log-out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{HeadsUpWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserLive.Confirmation, :edit
      live "/users/confirm", UserLive.ConfirmationInstructions, :new
    end
  end
end
