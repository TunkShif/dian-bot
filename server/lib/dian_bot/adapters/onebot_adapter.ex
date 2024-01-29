defmodule DianBot.Adapters.OnebotAdapter do
  @behaviour DianBot.Adapter

  use Tesla, only: [:get, :post]

  alias DianBot.Schemas.{User, Group, Message}

  plug Tesla.Middleware.BaseUrl, base_url()
  plug Tesla.Middleware.Headers, [{"authorization", access_token()}]
  plug Tesla.Middleware.JSON

  defp config, do: Application.fetch_env!(:dian, DianBot)
  defp base_url, do: config() |> Keyword.fetch!(:base_url)
  defp access_token, do: config() |> Keyword.fetch!(:access_token)

  @impl true
  def is_online() do
    with {:ok, response} <- get("/get_status"),
         {:ok, data} <- handle_response(response) do
      data["online"]
    else
      _ -> false
    end
  end

  @impl true
  def get_user(qid) do
    with {:ok, response} <- get("/get_stranger_info", query: [user_id: qid]),
         {:ok, data} <- handle_response(response) do
      {:ok, %User{qid: qid, nickname: data["nickname"]}}
    end
  end

  @impl true
  def get_group(gid) do
    with {:ok, response} <- get("/get_group_info", query: [group_id: gid]),
         {:ok, data} <- handle_response(response) do
      {:ok, %Group{gid: gid, name: data["group_name"], description: data["group_memo"]}}
    end
  end

  @impl true
  def get_message(mid) do
    with {:ok, response} <- get("/get_msg", query: [message_id: mid]),
         {:ok, data} <- handle_response(response) do
      {:ok,
       %Message{
         mid: mid,
         qid: data["sender"]["user_id"],
         gid: data["group_id"],
         raw_text: data["raw_message"],
         sent_at: data["time"] |> DateTime.from_unix!()
       }}
    end
  end

  @impl true
  def get_forwarded_messages(mid) do
    with {:ok, response} <- get("/get_forward_msg", query: [message_id: mid]),
         {:ok, data} <- handle_response(response) do
      {:ok,
       for message <- data["messages"] do
         %Message{
           qid: message["sender"]["user_id"],
           gid: message["group_id"],
           raw_text: message["content"],
           sent_at: message["time"] |> DateTime.from_unix!()
         }
       end}
    end
  end

  @impl true
  def send_group_message(gid, message) do
    with {:ok, response} <- post("/send_group_msg", %{group_id: gid, message: message}),
         {:ok, _data} <- handle_response(response) do
      :ok
    end
  end

  @impl true
  def set_honorable_message(mid) do
    with {:ok, response} <- post("/set_essence_msg", %{message_id: mid}),
         {:ok, _data} <- handle_response(response) do
      :ok
    end
  end

  defp handle_response(%Tesla.Env{} = response) do
    case response do
      %{status: 200, body: %{"status" => "ok"} = body} -> {:ok, body["data"]}
      %{status: 200, body: body} -> {:error, body["msg"]}
      %{status: 400} -> {:error, "unknown bot api"}
      _ -> {:error, "bot api error"}
    end
  end
end
