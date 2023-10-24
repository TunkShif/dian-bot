defmodule DianWeb.AccountController do
  use DianWeb, :controller

  alias Dian.Accounts

  action_fallback DianWeb.FallbackController

  # TODO: rate limit
  def create(conn, params) do
    case Accounts.deliver_registration(params["id"], &url(~p"/users/confirm/#{&1}")) do
      {:ok, _result} ->
        json(conn, %{data: nil, message: "Registration confirmation email sent."})

      {:error, :exists} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: %{detail: "User already registered."}})

      error ->
        error
    end
  end

  def verify(conn, params) do
    case Accounts.verify_user_token(params["token"]) do
      {:ok, user} ->
        conn
        |> put_view(json: DianWeb.UserJSON)
        |> render(:show, user: user)

      {:error, :exists} ->
        already_exists_error(conn)

      error ->
        error
    end
  end

  def confirm(conn, params) do
    case Accounts.register_user(params["token"], params) do
      {:ok, user} ->
        conn
        |> put_view(json: DianWeb.UserJSON)
        |> render(:show, user: user)

      {:error, :exists} ->
        already_exists_error(conn)

      error ->
        error
    end
  end

  defp already_exists_error(conn) do
    conn
    |> put_status(:bad_request)
    |> json(%{errors: %{detail: "User already registered."}})
  end
end
