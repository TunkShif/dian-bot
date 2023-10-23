defmodule DianWeb.GroupController do
  use DianWeb, :controller

  alias Dian.Messenger

  def index(conn, _params) do
    groups = Messenger.list_messenger_groups()
    render(conn, :index, groups: groups)
  end
end
