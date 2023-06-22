defmodule DianWeb.AuthController do
  use DianWeb, :controller

  alias DianWeb.Auth
  alias Dian.Accounts

  def create(conn, %{"user" => user_params}) do
    %{"qq_number" => qq_number, "password" => password} = user_params

    case Accounts.get_user_by_credentials(qq_number, password) do
      {:ok, user} ->
        conn
        |> Auth.log_in_user(user, user_params)

      {:error, :not_found} ->
        conn
        |> put_flash(:error, "还没绑定帐号呢")
        |> redirect(to: ~p"/users/register")

      {:error, :wrong_password} ->
        conn
        |> put_flash(:error, "帐号密码不匹配")
        |> redirect(to: ~p"/users/login")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "退出登录了")
    |> Auth.log_out_user()
  end
end
