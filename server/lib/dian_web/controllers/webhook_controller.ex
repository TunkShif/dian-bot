defmodule DianWeb.WebhookController do
  use DianWeb, :controller

  alias DianWeb.BodyReader

  def event(conn, params) do
    payload = BodyReader.get_raw_body(conn)
    signature = get_req_header(conn, "x-signature") |> List.first()
    maybe_event = DianBot.parse_event(params, payload: payload, signature: signature)

    case maybe_event do
      nil -> conn |> put_status(:unauthorized) |> json(%{success: false, data: nil})
      _ -> conn |> json(%{success: true, data: nil})
    end
  end
end
