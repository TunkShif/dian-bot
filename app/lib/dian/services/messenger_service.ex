defmodule Dian.MessengerService do
  alias Dian.{Messenger, Profiles}

  def list_groups() do
    Messenger.list_messenger_groups()
  end

  def list_users() do
    Profiles.list_profiles_users()
  end
end
