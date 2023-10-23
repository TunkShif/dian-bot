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

  def one(%Hotword{} = hotword) do
    hotword.keyword
  end
end
