defmodule DianWeb.Router do
  use DianWeb, :router

  import DianWeb.Auth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {DianWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", DianWeb do
    pipe_through(:browser)

    live_session :default, on_mount: [{DianWeb.Auth, :mount_current_user}] do
      live("/", HomeLive)

      live("/users/login", LoginLive)
      live("/users/register", RegisterLive)
    end

    post("/users/login", AuthController, :create)
    delete("/users/logout", AuthController, :delete)
  end

  scope "/", DianWeb do
    pipe_through(:api)

    post("/event/incoming", EventController, :incoming)
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
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: DianWeb.Telemetry)
    end
  end
end
