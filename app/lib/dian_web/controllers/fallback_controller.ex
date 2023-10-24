defmodule DianWeb.FallbackController do
  use DianWeb, :controller
  require Logger

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: DianWeb.ErrorJSON)
    |> render("404.json")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: DianWeb.ErrorJSON)
    |> render("401.json")
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: DianWeb.ErrorJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, error) do
    Logger.error(inspect(error))

    conn
    |> put_status(:internal_server_error)
    |> put_view(json: DianWeb.ErrorJSON)
    |> render("500.json")
  end
end
