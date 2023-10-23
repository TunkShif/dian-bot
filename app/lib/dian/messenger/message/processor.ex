defmodule Dian.Messenger.Message.Processor do
  alias Dian.{Messenger, Supabase}

  # TODO: error handling
  def process(content) when is_list(content) do
    for code <- content do
      Task.async(fn -> process_code(code) end)
    end
    |> Task.await_many()
  end

  def raw_text(content) do
    for(%{"type" => type, "data" => data} <- content, type == "text", do: data)
    |> List.flatten()
    |> Enum.join(" ")
  end

  defp process_code(%{"type" => "text", "data" => data} = item) do
    %{item | "data" => String.split(data, "\n")}
  end

  defp process_code(%{"type" => "at", "data" => data} = item) do
    number = data["qq"]
    {:ok, user} = Messenger.get_user(number)

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
        Finch.build(:get, url) |> Finch.request!(Dian.Finch)

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
