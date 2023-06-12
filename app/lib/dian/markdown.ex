defmodule Dian.Markdown do
  def to_html!(source) when is_binary(source) do
    source
    |> Earmark.as_html!(compact_output: true, escape: false)
    |> HtmlSanitizeEx.markdown_html()
  end
end
