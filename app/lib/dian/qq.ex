defmodule Dian.QQ do
  use Tesla

  plug Tesla.Middleware.BaseUrl, Application.get_env(:dian, Dian.QQ)[:base_url]

  plug Tesla.Middleware.Headers, [
    {"authorization", Application.get_env(:dian, Dian.QQ)[:access_token]}
  ]

  plug Tesla.Middleware.JSON

  def get_message_by_id(id) do
    get("/get_msg", query: [message_id: id])
  end
end
