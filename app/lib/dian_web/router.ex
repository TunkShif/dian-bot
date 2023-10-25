defmodule DianWeb.Router do
  use DianWeb, :router

  import DianWeb.Auth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DianWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :event do
    plug :accepts, ["json"]
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :fetch_current_user
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:dian, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DianWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/", DianWeb do
    pipe_through :event

    post "/event/incoming", EventController, :create
  end

  scope "/api", DianWeb do
    pipe_through :api

    get "/favorites/diaans/images", DiaanController, :images
    resources "/favorites/diaans", DiaanController, only: [:index, :show, :update, :delete]

    resources "/messenger/messages", MessageController, only: [:show], param: "number"
    resources "/messenger/users", UserController, only: [:index]
    resources "/messenger/groups", GroupController, only: [:index]

    get "/statistics/hotwords", StatisticsController, :list_hotwords
    get "/statistics/dashboard", StatisticsController, :get_dashboard_statistics
    get "/statistics/user/:id", StatisticsController, :get_user_statistics

    post "/account/users/login", SessionController, :create
    get "/account/users/me", SessionController, :show
    get "/account/users/logout", SessionController, :delete

    get "/account/users/verify/:token", AccountController, :verify
    post "/account/users/confirm/:token", AccountController, :confirm
    post "/account/users/request/:id", AccountController, :create

    post "/notification/subscriptions/create", NotificationController, :create
    post "/notification/subscriptions/current", NotificationController, :show
    post "/notification/subscriptions/cancel", NotificationController, :delete
  end

  scope "/", DianWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
