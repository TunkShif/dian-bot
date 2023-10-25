defmodule DianWeb.NotificationController do
  use DianWeb, :controller
  import DianWeb.Auth

  alias Dian.Notification

  plug :require_authenticated_user

  def create(conn, %{"subscription" => subscription}) do
    current_user = conn.assigns[:current_user]

    subscription_params = %{
      endpoint: subscription["endpoint"],
      subscription: subscription,
      user_id: current_user.id
    }

    with {:ok, subscription} <- Notification.create_subscription(subscription_params) do
      render(conn, :show, subscription: subscription)
    end
  end

  def show(conn, %{"endpoint" => endpoint}) do
    subscription = Notification.get_subscription_by_endpoint(endpoint)
    render(conn, :show, subscription: subscription)
  end

  def delete(conn, %{"endpoint" => endpoint}) do
    subscription = Notification.get_subscription_by_endpoint(endpoint)
    Notification.delete_subscription(subscription)
    render(conn, :show, subscription: subscription)
  end
end
