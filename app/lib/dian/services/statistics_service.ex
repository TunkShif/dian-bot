defmodule Dian.StatisticsService do
  alias Dian.Statistics

  def list_hotwords() do
    Statistics.list_hotwords()
  end

  def get_dashboard_statistics() do
    tasks = [
      Task.async(&Statistics.get_most_recent_sender/0),
      Task.async(&Statistics.get_latest_activity_count/0),
      Task.async(&Statistics.get_last_week_activity_count/0),
      Task.async(&Statistics.get_last_month_active_user/0)
    ]

    Task.await_many(tasks)
  end

  def get_user_statistics(id) do
    Statistics.get_user_statistics(id)
  end
end
