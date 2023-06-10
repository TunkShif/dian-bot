defmodule Dian.QQ do
  use Tesla

  import Dian.Helpers

  plug Tesla.Middleware.BaseUrl, base_url()
  plug Tesla.Middleware.Headers, [{"authorization", access_token()}]
  plug Tesla.Middleware.JSON

  defp base_url, do: Application.get_env(:dian, Dian.QQ)[:base_url]
  defp access_token, do: Application.get_env(:dian, Dian.QQ)[:access_token]

  defp validate_response(%{status: 200, body: %{"status" => "ok", "data" => data}}) do
    {:ok, data}
  end

  defp validate_response(%{status: status, body: body}) do
    {:error,
     %{
       status: status,
       message: body["message"]
     }}
  end

  def get_user_avator_by_number(number, size \\ 100) do
    "https://q.qlogo.cn/g?b=qq&nk=#{number}&s=#{size}"
  end

  def get_message(id) do
    with {:ok, response} <- get("/get_msg", query: [message_id: id]),
         {:ok, data} <- validate_response(response) do
      # TODO: assume only group messages are allowed for now
      %{
        "group_id" => group_number,
        "message_id" => message_number,
        "sender" => %{"user_id" => sender_number, "nickname" => sender_nickname},
        "message" => raw_content,
        "time" => sent_at
      } = data

      {:ok,
       %{
         number: "#{message_number}",
         sent_at: convert_unix_timestamp!(sent_at),
         raw_content: raw_content,
         sender: %{
           number: "#{sender_number}",
           nickname: sender_nickname
         },
         group: %{
           number: "#{group_number}"
         }
       }}
    end
  end

  def get_user(id) do
    with {:ok, response} <- get("/get_stranger_info", query: [user_id: id]),
         {:ok, data} <- validate_response(response) do
      {:ok, %{number: "#{id}", nickname: data["nickname"]}}
    end
  end

  def get_group(id) do
    with {:ok, response} <- get("/get_group_info", query: [group_id: id]),
         {:ok, data} <- validate_response(response) do
      {:ok, %{number: "#{id}", name: data["group_name"]}}
    end
  end

  def get_image(file) do
    with {:ok, response} <- get("/get_image", query: [file: file]),
         {:ok, data} <- validate_response(response) do
      {:ok, %{filename: data["filename"], url: data["url"]}}
    end
  end

  def set_essence_message(id) do
    with {:ok, response} <- get("/set_essence_msg", query: [message_id: id]),
         {:ok, _data} <- validate_response(response) do
      {:ok, :success}
    end
  end

  def send_private_message(user_id, group_id, content) do
    with {:ok, response} <-
           post("/send_private_msg", %{user_id: user_id, group_id: group_id, message: content}),
         {:ok, data} <- validate_response(response) do
      %{"message_id" => message_number} = data

      {:ok, %{number: "#{message_number}"}}
    end
  end

  def send_group_message(group_id, content) do
    with {:ok, response} <-
           post("/send_group_msg", %{group_id: group_id, message: content}),
         {:ok, data} <- validate_response(response) do
      %{"message_id" => message_number} = data

      {:ok, %{number: message_number}}
    end
  end
end
