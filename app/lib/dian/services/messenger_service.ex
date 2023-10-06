defmodule Dian.MessengerService do
  alias Dian.{Messenger, Profiles}

  def list_groups() do
    Messenger.list_messenger_groups()
  end

  def list_users() do
    Profiles.list_profiles_users()
  end

  def get_message(number) do
    Messenger.get_or_create_message(number)
  end
end
