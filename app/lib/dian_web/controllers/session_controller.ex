defmodule DianWeb.SessionController do
  use DianWeb, :controller

  alias Dian.Accounts
  alias DianWeb.Auth

  def create(conn, params) do
    %{"user" => id, "password" => password} = params

    if profile = Accounts.get_user_by_password(id, password) do
      conn
      |> put_session(:user_return_to, ~p"/?login_success=true")
      |> Auth.log_in_user(profile.user, params)
    else
      conn
      |> redirect(to: ~p"/users/login?login_failed=true")
    end
  end

  def show(conn, _params) do
    conn = Auth.fetch_current_user(conn, [])

    conn
    |> put_view(json: DianWeb.UserJSON)
    |> render(:current, user: conn.assigns[:current_user])
  end

  def delete(conn, _params) do
    Auth.log_out_user(conn)
  end
end
