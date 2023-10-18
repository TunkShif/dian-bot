defmodule Dian.DiaanService do
  alias Dian.{Favorites, Statistics}

  def list_all(params) do
    if keyword = params["keyword"] do
      Task.async(fn -> Statistics.create_hotword(%{keyword: keyword}) end)
    end

    Favorites.list_favorites_diaans(params)
  end

  def list_images(params) do
    Favorites.list_favorites_images(params)
  end

  def get_one(params) do
    Favorites.get_diaan(params["id"])
  end
end
