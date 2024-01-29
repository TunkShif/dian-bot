defmodule DianWeb.WebhookController do
  use DianWeb, :controller

  alias DianWeb.BodyReader

  def event(conn, params) do
    payload = BodyReader.get_raw_body(conn)
    signature = get_req_header(conn, "x-signature") |> List.first()
    event = DianBot.parse_event(params, payload: payload, signature: signature)

    # TODO event handler

    conn |> json(%{success: true, data: nil})
  end
end
