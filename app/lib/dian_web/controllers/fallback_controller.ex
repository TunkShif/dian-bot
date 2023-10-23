defmodule DianWeb.FallbackController do
  use DianWeb, :controller
  require Logger

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: DianWeb.ErrorJSON)
    |> render("404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: DianWeb.ErrorJSON)
    |> render("401")
  end

  def call(conn, {:error, reason}) do
    Logger.error(reason)

    conn
    |> put_status(:internal_server_error)
    |> put_view(json: DianWeb.ErrorJSON)
    |> render("500")
  end
end
