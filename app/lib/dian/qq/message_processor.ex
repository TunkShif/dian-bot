defmodule Dian.QQ.MessageProcessor do
  alias Dian.Supabase
  alias Dian.Profiles

  # TODO: error handling
  def process(content) when is_list(content) do
    content
    |> Enum.map(&process_code/1)
  end

  defp process_code(%{"type" => "text", "data" => data} = item) do
    %{item | "data" => String.split(data, "\n")}
  end

  defp process_code(%{"type" => "at", "data" => data} = item) do
    number = data["qq"]
    user = Profiles.get_or_create_user(number)

    %{
      item
      | "data" => %{
          "number" => number,
          "nickname" => user.nickname
        }
    }
  end

  defp process_code(%{"type" => "image", "data" => data} = item) do
    filename = data["file"]
    url = data["url"]

    {:ok, exists?} = Supabase.object_exists?("images", filename)

    unless exists? do
      %{status: 200, body: body, headers: headers} =
        Finch.build(:get, url) |> Finch.request!(FinchClient)

      {_, content_type} = headers |> Enum.find(&match?({"content-type", _}, &1))
      {:ok, _} = Supabase.create_object("images", filename, body, content_type)
    end

    %{
      item
      | "data" => %{
          "url" => Supabase.get_public_object_url("images", filename)
        }
    }
  end

  defp process_code(item), do: item
end
