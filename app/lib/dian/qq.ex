defmodule Dian.QQ do
  use Tesla

  plug Tesla.Middleware.BaseUrl, base_url()
  plug Tesla.Middleware.Headers, [{"authorization", access_token()}]
  plug Tesla.Middleware.JSON

  defp base_url, do: Application.get_env(:dian, Dian.QQ)[:base_url]
  defp access_token, do: Application.get_env(:dian, Dian.QQ)[:access_token]

  def get_user_avator_by_number(number, size \\ 100) do
    "https://q.qlogo.cn/g?b=qq&nk=#{number}&s=#{size}"
  end

  # TODO: refactor

  def get_message_by_id(id) do
    case get("/get_msg", query: [message_id: id]) do
      {:ok, %{status: 200, body: %{"status" => "ok", "data" => data}}} ->
        {:ok, data}

      error ->
        error
    end
  end

  def get_group_by_id(id) do
    case get("/get_group_info", query: [group_id: id]) do
      {:ok, %{status: 200, body: %{"status" => "ok", "data" => data}}} ->
        {:ok, data}

      error ->
        error
    end
  end

  def get_image(file) do
    case get("/get_image", query: [file: file]) do
      {:ok, %{status: 200, body: %{"status" => "ok", "data" => data}}} ->
        {:ok, data}

      error ->
        error
    end
  end

  def set_essence_msg(id) do
    case get("/set_essence_msg", query: [message_id: id]) do
      {:ok, %{status: 200, body: body}} ->
        {:ok, body}

      error ->
        error
    end
  end

  def send_group_msg(id, content) do
    case post("/send_group_msg", %{group_id: id, message: content}) do
      {:ok, %{status: 200, body: body}} ->
        {:ok, body}

      error ->
        error
    end
  end
end
