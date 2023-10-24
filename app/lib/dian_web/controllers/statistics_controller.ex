defmodule DianWeb.StatisticsController do
  use DianWeb, :controller

  alias Dian.StatisticsService

  action_fallback DianWeb.FallbackController

  def list_hotwords(conn, _params) do
    hotwords = StatisticsService.list_hotwords()
    render(conn, :hotwords, hotwords: hotwords)
  end

  def get_dashboard_statistics(conn, _params) do
    [user, counts, charts, users] = StatisticsService.get_dashboard_statistics()
    render(conn, :dashboard, user: user, counts: counts, charts: charts, users: users)
  end

  def get_user_statistics(conn, %{"id" => id}) do
    counts = StatisticsService.get_user_statistics(id)
    render(conn, :user, counts: counts)
  end
end
