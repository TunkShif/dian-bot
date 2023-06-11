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

    <section class="my-4 flex justify-center items-center">
      <button
        :if={@cursor}
        phx-click="load_more"
        class={[
          "focus:outline-none focus-visible:outline-0 disabled:cursor-not-allowed disabled:opacity-75",
          "flex-shrink-0 font-medium rounded-md text-sm gap-x-1.5 px-2.5 py-1.5",
          "shadow-sm ring-1 ring-inset ring-zinc-300 dark:ring-zinc-700 text-zinc-700 dark:text-zinc-50",
          "bg-white hover:bg-zinc-50 active:bg-zinc-100 disabled:bg-white dark:bg-zinc-900 dark:hover:bg-zinc-800 dark:active:bg-zinc-950 dark:disabled:bg-zinc-900",
          "focus-visible:ring-2 focus-visible:ring-primary-500 dark:focus-visible:ring-primary-400 inline-flex items-center"
        ]}
      >
        多来点
      </button>
      <p :if={@cursor == nil} class="text-xs text-right text-zinc-600 dark:text-zinc-500">
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
        <p class="text-xs text-right text-zinc-600 dark:text-zinc-500">
          现在一共有
          <span class="text-slate-800 dark:text-zinc-400 font-medium"><%= @online_count %></span>
          人在翻阅合订本
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
