defmodule DianWeb.UserController do
  use DianWeb, :controller

  alias Dian.Messenger

  action_fallback DianWeb.FallbackController

  def index(conn, _params) do
    users = Messenger.list_messenger_users()
    render(conn, :index, users: users)
  end
end
