defmodule DianWeb.StatisticsJSON do
  alias Dian.Statistics.Hotword

  alias DianWeb.UserJSON

  def hotwords(%{hotwords: hotwords}) do
    %{data: for(hotword <- hotwords, do: one(hotword))}
  end

  def dashboard(%{user: user, counts: counts, charts: charts, users: users}) do
    %{
      data: %{
        most_recent_active_user: UserJSON.one(user),
        latest_activity_counts: counts,
        last_week_activity_counts: charts,
        last_month_active_users:
          for(
            %{count: count, sender: sender} <- users,
            do: %{count: count, sender: UserJSON.one(sender)}
          )
      }
    }
  end

  def user(%{counts: counts}) do
    %{data: counts}
  end

  def heatmap(%{data: data}) do
    %{
      data:
        for(
          %{date: date, count: count} <- data,
          do: %{
            date: Calendar.strftime(date, "%Y/%m/%d"),
            count: count
          }
        )
    }
  end

  def wrapped(%{top_operator: top_operator, top_sender: top_sender, counts: counts}) do
    %{
      data: %{
        counts: counts,
        top_operator: top_operator && UserJSON.one(top_operator),
        top_sender: top_sender && UserJSON.one(top_sender)
      }
    }
  end

  def one(%Hotword{} = hotword) do
    hotword.keyword
  end
end
