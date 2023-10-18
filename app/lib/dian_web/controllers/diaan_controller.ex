defmodule DianWeb.DiaanController do
  use DianWeb, :controller

  alias Dian.DiaanService

  def index(conn, params) do
    {entries, metadata} = DiaanService.list_all(params)
    render(conn, :index, diaans: entries, metadata: metadata)
  end

  def show(conn, params) do
    entry = DiaanService.get_one(params)

    if entry do
      render(conn, :show, diaan: entry)
    else
      put_status(conn, :not_found)
      |> json(%{error: "not found"})
    end
  end

  def list_images(conn, params) do
    {entries, metadata} = DiaanService.list_images(params)
    render(conn, :index, diaans: entries, metadata: metadata)
  end
end
