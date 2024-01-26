defmodule Dian.Feeds.Entry do
  alias Dian.Favorites.Diaan

  defstruct [:id, :title, :author, :content, :inserted_at]

  def from_dian(%Diaan{id: id, message: message, inserted_at: inserted_at}) do
    %__MODULE__{
      id: id,
      title: "#{message.sender.nickname} - #{Calendar.strftime(inserted_at, "%Y-%m-%d %I:%M:%S %p")}",
      author: message.sender.nickname,
      content: Enum.map(message.content, &render_content/1) |> List.flatten(),
      inserted_at: inserted_at
    }
  end

  defp render_content(%{"type" => "text", "data" => data}) do
    for text <- data do
      """
      <p>#{html_escape(text)}<p>
      """
    end
  end

  defp render_content(%{"type" => "at", "data" => %{"nickname" => nickname}}) do
    """
    <em>@#{html_escape(nickname)}</em>
    """
  end

  defp render_content(%{"type" => "image", "data" => %{"url" => url}}) do
    """
    <img src="#{html_escape(url)}">
    """
  end

  defp render_content(_), do: ""

  defp html_escape(raw), do: raw |> Phoenix.HTML.html_escape() |> Phoenix.HTML.safe_to_string()
end
