defmodule Dian.Statistics do
  @moduledoc """
  The Statistics context.
  """

  import Ecto.Query, warn: false

  alias Dian.Repo
  alias Dian.Statistics.Hotword
  alias Dian.Favorites.Diaan
  alias Dian.Messenger.{User, Message}

  @pubsub Dian.PubSub

  def topic(type), do: "statistics:#{type}"

  def subscribe(type) do
    Phoenix.PubSub.subscribe(@pubsub, topic(type))
  end

  def broadcast(type, message) do
    Phoenix.PubSub.broadcast(@pubsub, topic(type), message)
  end

  @doc """
  Returns the list of hotwords.

  ## Examples

      iex> list_hotwords()
      [%Hotword{}, ...]

  """
  def list_hotwords do
    Repo.all(from h in Hotword, order_by: [desc: h.updated_at, desc: h.id])
  end

  def get_most_recent_sender() do
    query =
      from d in Diaan,
        join: message in assoc(d, :message),
        join: sender in assoc(message, :sender),
        limit: 1,
        order_by: [desc: d.marked_at],
        select: sender

    Repo.one(query)
  end

  def get_latest_activity_count() do
    today = Date.utc_today()
    yesterday = today |> Date.add(-1)

    query =
      from d in Diaan,
        where: fragment("?::date >= ?", d.marked_at, ^yesterday),
        select: %{
          today: fragment("SUM(CASE WHEN ?::date = ? THEN 1 ELSE 0 END)", d.marked_at, ^today),
          yesterday:
            fragment("SUM(CASE WHEN ?::date = ? THEN 1 ELSE 0 END)", d.marked_at, ^yesterday)
        }

    Repo.one(query)
  end

  def get_last_week_activity_count() do
    last_week_end = Date.utc_today()
    last_week_start = last_week_end |> Date.add(-7)

    query =
      from(d in Diaan,
        where:
          fragment("?::date >= ?", d.marked_at, ^last_week_start) and
            fragment("?::date <= ?", d.marked_at, ^last_week_end),
        group_by: fragment("DATE(?)", d.marked_at),
        order_by: fragment("DATE(?)", d.marked_at),
        select: %{date: fragment("DATE(?)", d.marked_at), count: count()}
      )

    records = Repo.all(query)

    for day <- 1..7,
        date = Date.add(last_week_end, -(day - 1)) do
      %{count: 0, date: date}
    end
    |> Enum.concat(records)
    |> Enum.reduce(%{}, fn item, acc ->
      date = item.date

      case Map.get(acc, date) do
        nil -> Map.put(acc, date, item)
        existing_item when existing_item.count < item.count -> Map.put(acc, date, item)
        _ -> acc
      end
    end)
    |> Map.values()
    |> Enum.take(7)
  end

  def get_last_month_active_user() do
    last_month_end = Date.utc_today()
    last_month_start = last_month_end |> Date.add(-30)

    query =
      from d in Diaan,
        join: message in assoc(d, :message),
        join: sender in assoc(message, :sender),
        where:
          fragment("?::date >= ?", d.marked_at, ^last_month_start) and
            fragment("?::date <= ?", d.marked_at, ^last_month_end),
        group_by: sender.id,
        order_by: [desc: count(d.id)],
        select: %{sender: sender, count: count(d.id)},
        limit: 10

    Repo.all(query)
  end

  def get_user_statistics(number) do
    as_operator =
      Repo.one(
        from d in Diaan,
          join: operator in assoc(d, :operator),
          where: operator.number == ^number,
          group_by: operator.id,
          select: count(d.id)
      )

    as_sender =
      Repo.one(
        from m in Message,
          join: sender in assoc(m, :sender),
          where: sender.number == ^number,
          group_by: sender.id,
          select: count(m.id)
      )

    %{as_operator: as_operator, as_sender: as_sender}
  end

  def get_heatmap_statistics() do
    last_date = DateTime.utc_now() |> DateTime.add(-(30 * 6), :day)

    Repo.all(
      from d in Diaan,
        where: d.inserted_at > ^last_date,
        group_by: fragment("date_trunc('day', ?)", d.inserted_at),
        order_by: [desc: fragment("date_trunc('day', ?)", d.inserted_at)],
        select: %{date: fragment("date_trunc('day', ?)", d.inserted_at), count: count()}
    )
  end

  def get_top_groups_of_messages(year) do
    Repo.all(
      from m in Message,
        join: group in assoc(m, :group),
        where: fragment("extract(year from ?) = ?", m.inserted_at, ^year),
        group_by: [group.id, group.name],
        order_by: [desc: count(m.id)],
        limit: 5,
        select: %{group_name: group.name, messsage_count: count(m.id)}
    )
  end

  def get_top_users_of_messages(year) do
    Repo.all(
      from m in Message,
        join: user in assoc(m, :sender),
        where: fragment("extract(year from ?) = ?", m.inserted_at, ^year),
        group_by: user.id,
        order_by: [desc: count(m.id)],
        limit: 5,
        select: %{user: user, message_count: count(m.id)}
    )
  end

  def get_top_user_operated_by(number) do
    Repo.one(
      from dian in Diaan,
        join: operator in User,
        on: operator.number == ^number,
        join: message in Message,
        on: message.id == dian.message_id and dian.operator_id == operator.id,
        join: sender in assoc(message, :sender),
        group_by: sender.id,
        order_by: [desc: count(dian.id), desc: sender.id],
        limit: 1,
        select: sender
    )
  end

  def get_top_user_operated_on(number) do
    Repo.one(
      from dian in Diaan,
        join: operator in assoc(dian, :operator),
        join: message in assoc(dian, :message),
        join: sender in User,
        on: message.sender_id == sender.id and sender.number == ^number,
        group_by: operator.id,
        order_by: [desc: count(dian.id), desc: operator.id],
        limit: 1,
        select: operator
    )
  end

  @doc """
  Creates a hotword.

  ## Examples

      iex> create_hotword(%{field: value})
      {:ok, %Hotword{}}

      iex> create_hotword(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_hotword(attrs) do
    existing_one = Repo.get_by(Hotword, keyword: attrs.keyword)

    result =
      if existing_one do
        existing_one
        |> Hotword.changeset(%{})
        |> Repo.update(force: true)
      else
        count = Repo.one(from h in Hotword, select: count())

        if count >= 15 do
          oldest = Repo.one(from h in Hotword, order_by: [asc: h.updated_at], limit: 1)
          Repo.delete!(oldest)
        end

        %Hotword{}
        |> Hotword.changeset(attrs)
        |> Repo.insert()
      end

    result
  end
end
