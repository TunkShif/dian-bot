defmodule DianWeb.UserController do
  use DianWeb, :controller

  alias Dian.Messenger

  action_fallback DianWeb.FallbackController

  def index(conn, _params) do
    users = Messenger.list_messenger_users()
    render(conn, :index, users: users)
  end

  def avatar(conn, %{"number" => number}) do
    with {:ok, %Finch.Response{status: 200, body: body, headers: headers}} <-
           Finch.build(:get, "https://q.qlogo.cn/g?b=qq&nk=#{number}&s=100")
           |> Finch.request(Dian.Finch) do
      headers = Map.new(headers)

      conn
      |> put_resp_header("content-type", headers["content-type"])
      |> put_resp_header("last-modifed", headers["last-modified"])
      |> put_resp_header("cache-control", headers["cache-control"])
      |> send_resp(200, body)
    else
      _ ->
        conn
        |> put_view(json: DianWeb.ErrorJSON)
        |> render("404.json")
    end
  end
end
