defmodule DianWeb.MessengerController do
  use DianWeb, :controller

  alias Dian.MessengerService

  def list_groups(conn, _params) do
    groups = MessengerService.list_groups()
    render(conn, :groups, groups: groups)
  end

  def list_users(conn, _params) do
    users = MessengerService.list_users()
    render(conn, :users, users: users)
  end

  def get_message(conn, %{"number" => number}) do
    message = MessengerService.get_message(number)
    render(conn, :message, message: message)
  end
end
