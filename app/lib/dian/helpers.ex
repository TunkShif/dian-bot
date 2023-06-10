defmodule Dian.Helpers do
  def convert_unix_timestamp!(time) do
    time |> DateTime.from_unix!() |> DateTime.to_naive()
  end

  def format_datetime(datetime) do
    date = datetime |> NaiveDateTime.to_date() |> Date.to_string()

    time =
      datetime
      |> NaiveDateTime.to_time()
      |> Time.add(8, :hour)
      |> Time.truncate(:second)
      |> Time.to_string()

    "#{date} #{time}"
  end
end
