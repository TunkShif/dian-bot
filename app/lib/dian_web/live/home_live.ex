defmodule DianWeb.HomeLive do
  use DianWeb, :live_view

  alias Dian.QQ
  alias Dian.Favorites

  # TODO: realtime

  def mount(_params, _session, socket) do
    {:ok, stream(socket, :diaans, Favorites.list_favorites_diaans())}
  end

  def render(assigns) do
    ~H"""
    <section>
      <ul id="diaans" phx-update="stream" class="flex flex-col gap-4">
        <li :for={{dom_id, diaan} <- @streams.diaans}>
          <div id={dom_id} class="bg-white p-2.5 rounded flex flex-col gap-4">
            <header class="flex gap-2">
              <div class="w-11 h-11 rounded-full border border-zinc-50">
                <img
                  src={QQ.get_user_avator_by_number(diaan.message.sender.number)}
                  class="w-full h-full aspect-square rounded-full"
                />
              </div>
              <div class="flex flex-col justify-between">
                <span class="text-slate-800"><%= diaan.message.sender.nickname %></span>
                <span class="text-slate-600 text-xs">
                  <%= format_datetime(diaan.message.sent_at) %> 发送
                </span>
              </div>
            </header>

            <section class="px-2">
              <p class="break-words">
                <%= diaan.message.content %>
              </p>
            </section>

            <footer class="flex justify-between items-center">
              <span class="text-slate-600 text-xs">
                来自 <%= diaan.message.group.name %>
              </span>

              <span class="text-slate-600 text-xs">
                由 <%= diaan.operator.nickname %> 设置
              </span>
            </footer>
          </div>
        </li>
      </ul>
    </section>
    """
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
