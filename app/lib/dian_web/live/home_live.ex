defmodule DianWeb.HomeLive do
  use DianWeb, :live_view

  alias Dian.Favorites
  alias DianWeb.Presence

  # TODO: realtime

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Presence.subscribe()
      Presence.join()

      Favorites.subscribe()
    end

    {diaans, %{after: cursor}} = Favorites.list_favorites_diaans()

    {:ok,
     socket
     |> assign(online_count: Presence.count(), cursor: cursor)
     |> stream(:diaans, diaans)}
  end

  def render(assigns) do
    ~H"""
    <section>
      <ul id="diaans" phx-update="stream" class="mx-auto flex flex-col gap-4 w-auto md:w-[720px]">
        <.live_component
          :for={{dom_id, diaan} <- @streams.diaans}
          module={DianWeb.DiaanLiveComponent}
          id={dom_id}
          diaan={diaan}
        />
      </ul>
    </section>

    <section class="my-8 flex justify-center items-center">
      <.button :if={@cursor} phx-click="load_more">
        <svg
          class="animate-spin h-4 w-4 hidden phx-click-loading:block"
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
        >
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4">
          </circle>
          <path
            class="opacity-75"
            fill="currentColor"
            d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
          >
          </path>
        </svg>
        <span class="inline-block phx-click-loading:hidden"> 多来点 </span>
        <span class="hidden phx-click-loading:inline-block"> 加载中... </span>
      </.button>
      <p :if={@cursor == nil} class="text-xs text-right text-primary">
        已经到底了别翻了
      </p>
    </section>

    <section class="my-4 flex justify-end items-center">
      <div class="inline-flex justify-center items-center gap-2">
        <span class="relative flex justify-center items-center h-2 w-2">
          <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75">
          </span>
          <span class="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
        </span>
        <p class="text-xs text-right text-primary">
          现在一共有 <span class="text-emphasis font-medium"><%= @online_count %></span> 人在翻阅合订本
        </p>
      </div>
    </section>
    """
  end

  def handle_event("load_more", _parms, socket) do
    cursor = socket.assigns.cursor
    {diaans, %{after: cursor}} = Favorites.list_favorites_diaans(cursor)
    {:noreply, socket |> assign(cursor: cursor) |> stream(:diaans, diaans)}
  end

  def handle_info(%{topic: "joined", event: "presence_diff"}, socket) do
    {:noreply, socket |> assign(online_count: Presence.count())}
  end

  def handle_info({:added, diaan}, socket) do
    {:noreply, socket |> stream_insert(:diaans, diaan, at: 0)}
  end
end
