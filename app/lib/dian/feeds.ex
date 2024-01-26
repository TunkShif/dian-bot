defmodule Dian.Feeds do
  alias Dian.Favorites
  alias Atomex.{Feed, Entry}

  # TODO: cache
  # TODO: no hard-coded url

  def build() do
    last_updated = yesterday() |> DateTime.to_date()

    entries =
      Favorites.list_favorites_feeds(last_updated) |> Enum.map(&__MODULE__.Entry.from_dian/1)

    build_feed(entries)
  end

  defp build_feed(entries) do
    Feed.new("https://dian.tunkshif.one", yesterday(), "Little Red Book Feeds")
    |> Feed.author("Dian Bot", email: "tunkshif@qq.com")
    |> Feed.link("https://dian.tunkshif.one/feed", rel: "self")
    |> Feed.entries(Enum.map(entries, &build_entry/1))
    |> Feed.build()
    |> Atomex.generate_document()
  end

  defp build_entry(entry) do
    Entry.new(
      "https://dian.tunkshif.one/archive/#{entry.id}",
      entry.inserted_at |> DateTime.from_naive!("Etc/UTC"),
      entry.title
    )
    |> Entry.author(entry.author)
    |> Entry.content({:cdata, Enum.join(entry.content, "\n")}, type: "html")
    |> Entry.build()
  end

  defp yesterday,
    do:
      DateTime.utc_now()
      |> DateTime.add(8, :hour)
      |> DateTime.add(-24, :hour)
end
