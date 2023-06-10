defmodule Dian.Supabase do
  use Tesla

  alias Tesla.Multipart

  plug Tesla.Middleware.BaseUrl, base_url()
  plug Tesla.Middleware.BearerAuth, token: api_key()
  plug Tesla.Middleware.JSON

  defp base_url, do: Application.get_env(:dian, Dian.Supabase)[:base_url]
  defp api_key, do: Application.get_env(:dian, Dian.Supabase)[:api_key]

  def get_public_object_url(bucket_name, filename) do
    "#{base_url()}/storage/v1/object/public/#{bucket_name}/#{filename}"
  end

  def object_exists?(bucket_name, filename) do
    with {:ok, %{status: status}} <-
           get("/storage/v1/object/info/public/#{bucket_name}/#{filename}") do
      if status == 200 do
        {:ok, true}
      else
        {:ok, false}
      end
    else
      _ -> {:error, :unknown}
    end
  end

  def create_object(bucket_name, filename, content, content_type) do
    multipart =
      Multipart.new()
      |> Multipart.add_file_content(content, filename, headers: [{"content-type", content_type}])

    post("/storage/v1/object/#{bucket_name}/#{filename}", multipart)
  end
end
