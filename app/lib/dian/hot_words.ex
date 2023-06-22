defmodule Dian.HotWords do
  use Agent

  @topic "hotwords"
  @max_saved_count 15
  @max_keyword_length 10

  def subscribe() do
    Phoenix.PubSub.subscribe(Dian.PubSub, @topic)
  end

  def broadcast() do
    Phoenix.PubSub.broadcast(Dian.PubSub, @topic, "update:hotwords")
  end

  def start_link(_opts) do
    Agent.start_link(fn -> %{list: [], count: 0} end, name: __MODULE__)
  end

  def list() do
    Agent.get(__MODULE__, & &1.list)
  end

  def count() do
    Agent.get(__MODULE__, & &1.count)
  end

  def put(keyword) when is_binary(keyword) do
    unless check_exists(keyword) do
      check_size()

      if String.length(keyword) < @max_keyword_length do
        Agent.update(__MODULE__, &%{&1 | list: [keyword | &1.list], count: &1.count + 1})
      end
    end

    broadcast()
  end

  def put(_) do
    :ok
  end

  defp shift(keyword) do
    Agent.update(
      __MODULE__,
      &%{&1 | list: List.delete(&1.list, keyword) |> then(fn list -> [keyword | list] end)}
    )
  end

  defp check_exists(keyword) do
    if keyword in list() do
      shift(keyword)
      true
    else
      false
    end
  end

  defp check_size() do
    if count() >= @max_saved_count do
      Agent.update(
        __MODULE__,
        &%{&1 | list: List.delete_at(&1.list, &1.count - 1), count: &1.count - 1}
      )
    end
  end
end
