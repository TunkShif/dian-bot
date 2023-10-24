defmodule DianWeb.MessageController do
  use DianWeb, :controller

  alias Dian.Messenger

  action_fallback DianWeb.FallbackController

  def show(conn, %{"number" => number}) do
    with {:ok, message} <- Messenger.get_message(number) do
      render(conn, :show, message: message)
    end
  end
end
