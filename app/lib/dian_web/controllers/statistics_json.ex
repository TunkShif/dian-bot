defmodule DianWeb.StatisticsJSON do
  alias Dian.Statistics.Hotword
  alias Dian.Profiles.User

  def hotwords(%{hotwords: hotwords}) do
    %{data: for(hotword <- hotwords, do: Hotword.to_serializable(hotword))}
  end

  def dashboard(%{user: user, counts: counts, charts: charts, users: users}) do
    %{
      data: %{
        most_recent_active_user: user |> User.to_serializable(),
        latest_activity_counts: counts,
        last_week_activity_counts: charts,
        last_month_active_users:
          for(
            %{count: count, sender: sender} <- users,
            do: %{count: count, sender: sender |> User.to_serializable()}
          )
      }
    }
  end

  def user(%{counts: counts}) do
    %{data: counts}
  end
end
