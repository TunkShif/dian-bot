defmodule DianWeb.HomeLive do
  use DianWeb, :live_view

  alias Dian.QQ
  alias Dian.Favorites
  alias DianWeb.Presence

  # TODO: realtime

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Presence.subscribe()
      Presence.join()
    end

    {:ok,
     socket
     |> assign(online_count: Presence.count())
     |> stream(:diaans, Favorites.list_favorites_diaans())}
  end

  def render(assigns) do
    ~H"""
    <section>
      <ul id="diaans" phx-update="stream" class="flex flex-col gap-4">
        <.live_component
          :for={{dom_id, diaan} <- @streams.diaans}
          module={DianWeb.DiaanLiveComponent}
          id={dom_id}
          diaan={diaan}
        />
      </ul>
    </section>
    <section class="py-2">
      <p class="text-xs text-center text-slate-600">
        现在一共有 <span class="text-slate-800 font-medium"><%= @online_count %></span> 人在翻阅合订本
      </p>
    </section>
    """
  end

  def handle_info(%{topic: "joined", event: "presence_diff"}, socket) do
    {:noreply, socket |> assign(online_count: Presence.count())}
  end

  defp format_datetime(datetime) do
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
