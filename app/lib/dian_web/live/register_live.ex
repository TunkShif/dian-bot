defmodule DianWeb.RegisterLive do
  use DianWeb, :live_view

  alias Dian.Messenger

  def mount(_params, _session, socket) do
    groups = Messenger.list_messenger_groups()
    default_group = List.first(groups)
    {:ok, socket |> assign(groups: groups, default_group: default_group)}
  end

  def render(assigns) do
    ~H"""
    <div class="grid place-items-center h-auto md:h-[calc(100vh-0.25rem*22)]">
      <div class="card-primary p-4 md:px-6 w-full mx-2 md:w-[712px] min-h-[418px]">
        <header class="flex flex-col gap-1 md:gap-2">
          <h2 class="text-emphasis text-lg md:text-2xl font-semibold">绑定账号</h2>
          <p class="text-sm">你将绑定你的企鹅账号，扮演一位名为“旅行者”的神秘角色</p>
        </header>

        <div class="mt-4 relative">
          <div class="flex flex-col gap-2">
            <h3 class="text-primary md:text-lg font-medium">选择你的群组</h3>
            <.button
              class="w-auto md:w-2/3"
              phx-click={JS.exec("data-toggle", to: "#groups-select-content")}
            >
              <span><%= "#{@default_group.name} (#{@default_group.number})" %></span>
              <.icon name="hero-chevron-up-down-mini" class="w-5 h-5 ml-auto" />
            </.button>
          </div>

          <div
            id="groups-select-content"
            class="card-primary hidden absolute z-50 px-1.5 py-2 mt-2"
            data-toggle={
              JS.toggle(
                in:
                  {"ease-in duration-200 transform", "opacity-0 -translate-y-1",
                   "opacity-100 translate-y-0"},
                out: {"ease-out duration-200 transform", "opacity-100", "opacity-0"},
                time: 200
              )
            }
          >
            <div class="w-auto">
              <ul class="w-full flex flex-col text-primary">
                <.focus_wrap
                  id="groups-select-content-focus-wrap"
                  phx-window-keydown={JS.exec("data-toggle", to: "#groups-select-content")}
                  phx-key="escape"
                  phx-click-away={JS.exec("data-toggle", to: "#groups-select-content")}
                >
                  <li :for={group <- @groups} class="w-full text-sm text-emphasis font-medium">
                    <button class="text-left w-full px-2 py-1.5 rounded hover:bg-zinc-100 dark:hover:bg-zinc-800">
                      <%= "#{group.name} (#{group.number})" %>
                    </button>
                  </li>
                </.focus_wrap>
              </ul>
            </div>
          </div>
        </div>

        <div class="mt-4">
          <form>
            还没写好呢
          </form>
        </div>
      </div>
    </div>
    """
  end
end
