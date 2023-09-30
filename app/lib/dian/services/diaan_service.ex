defmodule Dian.DiaanService do
  alias Dian.{Favorites, Statistics}

  def list_all(params) do
    if keyword = params["keyword"] do
      Task.async(fn -> Statistics.create_hotword(%{keyword: keyword}) end)
    end

    Favorites.list_favorites_diaans(params)
  end
end
