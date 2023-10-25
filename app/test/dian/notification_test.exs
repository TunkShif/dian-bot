defmodule Dian.NotificationTest do
  use Dian.DataCase

  alias Dian.Notification

  describe "notification_subscriptions" do
    alias Dian.Notification.Subscription

    import Dian.NotificationFixtures

    @invalid_attrs %{endpoint: nil, subscription: nil}

    test "list_notification_subscriptions/0 returns all notification_subscriptions" do
      subscription = subscription_fixture()
      assert Notification.list_notification_subscriptions() == [subscription]
    end

    test "get_subscription!/1 returns the subscription with given id" do
      subscription = subscription_fixture()
      assert Notification.get_subscription!(subscription.id) == subscription
    end

    test "create_subscription/1 with valid data creates a subscription" do
      valid_attrs = %{endpoint: "some endpoint", subscription: %{}}

      assert {:ok, %Subscription{} = subscription} = Notification.create_subscription(valid_attrs)
      assert subscription.endpoint == "some endpoint"
      assert subscription.subscription == %{}
    end

    test "create_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notification.create_subscription(@invalid_attrs)
    end

    test "update_subscription/2 with valid data updates the subscription" do
      subscription = subscription_fixture()
      update_attrs = %{endpoint: "some updated endpoint", subscription: %{}}

      assert {:ok, %Subscription{} = subscription} = Notification.update_subscription(subscription, update_attrs)
      assert subscription.endpoint == "some updated endpoint"
      assert subscription.subscription == %{}
    end

    test "update_subscription/2 with invalid data returns error changeset" do
      subscription = subscription_fixture()
      assert {:error, %Ecto.Changeset{}} = Notification.update_subscription(subscription, @invalid_attrs)
      assert subscription == Notification.get_subscription!(subscription.id)
    end

    test "delete_subscription/1 deletes the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{}} = Notification.delete_subscription(subscription)
      assert_raise Ecto.NoResultsError, fn -> Notification.get_subscription!(subscription.id) end
    end

    test "change_subscription/1 returns a subscription changeset" do
      subscription = subscription_fixture()
      assert %Ecto.Changeset{} = Notification.change_subscription(subscription)
    end
  end
end
