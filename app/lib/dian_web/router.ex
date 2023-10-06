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

  pipeline :api do
    plug :accepts, ["json"]
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
    end
  end

  scope "/", DianWeb do
    pipe_through :api

    post "/event/incoming", EventController, :incoming
  end

  scope "/api", DianWeb do
    pipe_through :api

    resources "/diaans", DiaanController, only: [:index, :show, :update, :delete]

    get "/messenger/groups", MessengerController, :list_groups
    get "/messenger/users", MessengerController, :list_users
    get "/messenger/messages/:number", MessengerController, :get_message

    get "/statistics/hotwords", StatisticsController, :list_hotwords
    get "/statistics/dashboard", StatisticsController, :get_dashboard_statistics
    get "/statistics/user/:id", StatisticsController, :get_user_statistics
  end

  scope "/", DianWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
