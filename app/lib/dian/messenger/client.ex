defmodule Dian.Messenger.Client do
  use Tesla
  require Logger
  import Dian.Helpers

  alias Dian.Messenger.{User, Group}

  plug Tesla.Middleware.BaseUrl, base_url()
  plug Tesla.Middleware.Headers, [{"authorization", access_token()}]
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Logger, filter_headers: ["authorization"]

  defp config, do: Application.fetch_env!(:dian, Dian.Messenger.Client)
  defp base_url, do: Keyword.fetch!(config(), :base_url)
  defp access_token, do: Keyword.fetch!(config(), :access_token)

  def fetch_message(id) do
    with {:ok, response} <- get("/get_msg", query: [message_id: id]),
         {:ok, data} <- validate(response) do
      %{
        "group_id" => group_number,
        "message_id" => message_number,
        "sender" => %{"user_id" => sender_number},
        "message" => raw_content,
        "time" => sent_at
      } = data

      message =
        %{
          number: "#{message_number}",
          sent_at: convert_unix_timestamp!(sent_at),
          raw_content: raw_content,
          sender: "#{sender_number}",
          group: "#{group_number}"
        }

      {:ok, message}
    end
  end

  def fetch_user(user_id) do
    with {:ok, response} <- get("/get_stranger_info", query: [user_id: user_id]),
         {:ok, data} <- validate(response) do
      user = %User{nickname: data["nickname"], number: user_id}
      {:ok, user}
    end
  end

  def fetch_group(group_id) do
    with {:ok, response} <- get("/get_group_info", query: [group_id: group_id]),
         {:ok, data} <- validate(response) do
      group = %Group{name: data["group_name"], number: group_id}
      {:ok, group}
    end
  end

  def send_message(group_id, content) do
    with {:ok, response} <- post("/send_group_msg", %{group_id: group_id, message: content}),
         {:ok, data} <- validate(response) do
      message_id = data["message_id"]
      {:ok, message_id}
    end
  end

  def mark_message(message_id) do
    with {:ok, response} <- get("/set_essence_msg", query: [message_id: message_id]),
         {:ok, _data} <- validate(response) do
      {:ok, message_id}
    end
  end

  defp validate(%{status: 200, body: %{"status" => "ok", "data" => data}}) do
    {:ok, data}
  end

  defp validate(%{status: status, body: body}) do
    detail = %{status: status, message: body["msg"]}
    {:error, detail}
  end
end
