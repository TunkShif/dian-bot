defmodule DianWeb.NotificationJSON do
  alias Dian.Notification.Subscription

  def show(%{subscription: subscription}) do
    %{
      data: subscription && one(subscription)
    }
  end

  def one(%Subscription{subscription: subscription}) do
    subscription
  end
end
