defmodule Dian.Storage.Adapters.Supabase do
  @behaviour Dian.Storage.Adapter

  use Tesla

  plug Tesla.Middleware.BaseUrl, base_url()
  plug Tesla.Middleware.BearerAuth, token: api_key()
  plug Tesla.Middleware.JSON

  defp config, do: Application.fetch_env!(:dian, Dian.Storage)
  defp base_url, do: config() |> Keyword.fetch!(:base_url)
  defp api_key, do: config() |> Keyword.fetch!(:api_key)
  defp bucket_name, do: config() |> Keyword.fetch!(:bucket_name)

  @impl true
  def get_url(name) do
    "#{base_url()}/storage/v1/object/public/#{bucket_name()}/#{name}"
  end

  @impl true
  def exists?(name) do
    case get("/storage/v1/object/info/public/#{bucket_name()}/#{name}") do
      {:ok, %Tesla.Env{status: 200}} -> true
      _ -> false
    end
  end

  @impl true
  def upload(name, content, content_type: content_type) do
    payload =
      Tesla.Multipart.new()
      |> Tesla.Multipart.add_file_content(
        content,
        name,
        headers: [{"content-type", content_type}]
      )

    case post("/storage/v1/object/#{bucket_name()}/#{name}", payload) do
      {:ok, %Tesla.Env{status: 200}} -> {:ok, get_url(name)}
      error -> error
    end
  end
end
