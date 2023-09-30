defmodule DianWeb.DiaanController do
  use DianWeb, :controller

  alias Dian.DiaanService

  def index(conn, params) do
    {entries, metadata} = DiaanService.list_all(params)
    render(conn, :index, diaans: entries, metadata: metadata)
  end

  # def show(conn, _params) do
  # end
end
