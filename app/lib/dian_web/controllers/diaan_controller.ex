defmodule DianWeb.DiaanController do
  use DianWeb, :controller

  alias Dian.{Favorites, Statistics}

  # TODO

  def index(conn, params) do
    if keyword = params["keyword"] do
      Task.async(fn -> Statistics.create_hotword(%{keyword: keyword}) end)
    end

    {entries, metadata} = Favorites.list_favorites_diaans(params)
    render(conn, :index, diaans: entries, metadata: metadata)
  end

  def show(conn, params) do
    entry = Favorites.get_diaan(params["id"])

    if entry do
      render(conn, :show, diaan: entry)
    else
      put_status(conn, :not_found)
      |> json(%{error: "not found"})
    end
  end

  def images(conn, params) do
    {entries, metadata} = Favorites.list_favorites_images(params)
    render(conn, :index, diaans: entries, metadata: metadata)
  end
end
