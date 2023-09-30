defmodule DianWeb.PageController do
  use DianWeb, :controller

  def index(conn, _params) do
    render(conn, :app, layout: false)
  end
end
