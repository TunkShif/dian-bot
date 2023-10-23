defmodule DianWeb.UserController do
  alias Dian.Messenger
  use DianWeb, :controller

  def index(conn, _params) do
    users = Messenger.list_messenger_users()
    render(conn, :index, users: users)
  end
end
