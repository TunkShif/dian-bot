defmodule Dian.Notification.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notification_subscriptions" do
    field :endpoint, :string
    field :subscription, :map

    belongs_to :user, Dian.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:endpoint, :subscription, :user_id])
    |> validate_required([:endpoint, :subscription, :user_id])
  end
end
