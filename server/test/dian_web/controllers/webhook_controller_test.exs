defmodule DianWeb.WebhookControllerTest do
  use DianWeb.ConnCase, async: true

  describe "event" do
    test "fail with invalid event", %{conn: conn} do
      conn = post(conn, ~p"/webhooks/event", %{})
    end
  end
end
