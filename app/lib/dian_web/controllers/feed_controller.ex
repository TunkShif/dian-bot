defmodule DianWeb.FeedController do
  use DianWeb, :controller

  alias Dian.Feeds

  def index(conn, _params) do
    feeds = Feeds.build()
    conn |> text(feeds)
  end
end
