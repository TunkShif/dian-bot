defmodule DianWeb.EventController do
  use DianWeb, :controller

  def incoming(conn, params) do
    dbg(params)
    send_resp(conn, 200, "OK")
  end
end

