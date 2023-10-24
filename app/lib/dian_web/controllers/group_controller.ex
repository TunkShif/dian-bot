defmodule DianWeb.GroupController do
  use DianWeb, :controller

  alias Dian.Messenger

  action_fallback DianWeb.FallbackController

  def index(conn, _params) do
    groups = Messenger.list_messenger_groups()
    render(conn, :index, groups: groups)
  end
end
