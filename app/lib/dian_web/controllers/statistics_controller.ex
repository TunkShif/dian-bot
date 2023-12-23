defmodule DianWeb.StatisticsController do
  use DianWeb, :controller

  alias Dian.Statistics
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

  def get_user_statistics(conn, %{"number" => number}) do
    counts = StatisticsService.get_user_statistics(number)
    render(conn, :user, counts: counts)
  end

  def wrapped(conn, %{"number" => number}) do
    top_sender = Statistics.get_top_user_operated_by(number)
    top_operator = Statistics.get_top_user_operated_on(number)
    counts = StatisticsService.get_user_statistics(number)
    render(conn, :wrapped, top_operator: top_operator, top_sender: top_sender, counts: counts)
  end
end
