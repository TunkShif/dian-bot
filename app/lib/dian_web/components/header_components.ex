defmodule DianWeb.HeaderComponents do
  use DianWeb, :html

  def app_header(assigns) do
    ~H"""
    <header class="sticky top-0 inset-x-0 px-4 h-14 bg-white/75 backdrop-blur border-b border-zinc-900/10 dark:bg-zinc-900/75 dark:border-zinc-50/10 z-50">
      <div class="flex items-center justify-between py-3 text-sm">
        <.link navigate={~p"/"} class="group">
          <div class="flex items-center gap-4">
            <span class="text-xl">
              📕
            </span>
            <span class="font-medium text-emphasis group-hover:underline">Little Red Book</span>
          </div>
        </.link>

        <div class="flex items-center justify-end gap-2">
          <.theme_toggle />
          <.account_dropdown />
        </div>
      </div>
    </header>
    """
  end

  def theme_toggle(assigns) do
    ~H"""
    <.icon_button phx-click={JS.dispatch("theme:toggle")}>
      <span class="sr-only">theme toggle button</span>
      <.icon name="hero-sun-mini" class="dark:block hidden w-5 h-5" />
      <.icon name="hero-moon-mini" class="dark:hidden w-5 h-5" />
    </.icon_button>
    """
  end

  def account_dropdown(assigns) do
    ~H"""
    <div>
      <.icon_button phx-click={JS.exec("data-toggle", to: "#account-dropdown-content")}>
        <.icon name="hero-user-mini" class="w-5 h-5" />
      </.icon_button>
      <div
        id="account-dropdown-content"
        class="card-primary hidden absolute z-50 top-16 right-2 px-1.5 py-2"
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
        <div class="w-36">
          <ul class="w-full flex flex-col text-primary">
            <.focus_wrap
              id="account-dropdown-content-focus-wrap"
              phx-window-keydown={JS.exec("data-toggle", to: "#account-dropdown-content")}
              phx-key="escape"
              phx-click-away={JS.exec("data-toggle", to: "#account-dropdown-content")}
            >
              <li class="w-full">
                <.link
                  navigate={~p"/users/register"}
                  class="flex gap-1.5 items-center px-1 py-1.5 rounded hover:bg-zinc-100 dark:hover:bg-zinc-800"
                >
                  <svg
                    class="inline-block w-5 h-5"
                    xmlns="http://www.w3.org/2000/svg"
                    width="32"
                    height="32"
                    viewBox="0 0 24 24"
                  >
                    <path
                      fill="currentColor"
                      d="M20.194 18.424c-.419.05-1.576-1.777-1.735-2.031c-.005-.009-.018-.004-.018.006c-.012 1.215-.639 2.787-1.98 3.93a.009.009 0 0 0 .003.016c.666.207 2.122.749 1.772 1.34c-.285.482-4.902.308-6.235.157c-1.333.15-5.95.324-6.236-.157c-.353-.595 1.126-1.14 1.786-1.344v-.002c-1.36-1.153-1.991-2.748-1.992-3.971v-.001h-.002c-.05.08-1.309 2.11-1.75 2.057c-.21-.026-.486-1.158.364-3.894c.4-1.29.86-2.363 1.568-4.132C5.62 5.83 7.507 2 12 2c4.443 0 6.373 3.755 6.261 8.397c.707 1.766 1.168 2.845 1.568 4.132c.85 2.736.576 3.869.366 3.894Z"
                    />
                  </svg>
                  <span>绑定帐号</span>
                </.link>
              </li>
              <li class="w-full">
                <.link
                  navigate={~p"/users/login"}
                  class="flex gap-1.5 items-center w-full px-1 py-1.5 rounded hover:bg-zinc-100 dark:hover:bg-zinc-800"
                >
                  <.icon name="hero-arrow-right-on-rectangle-mini" class="w-5 h-5" />
                  <span>登录账号</span>
                </.link>
              </li>
              <li class="w-full">
                <.link class="flex gap-1.5 items-center w-full px-1 py-1.5 rounded hover:bg-zinc-100 dark:hover:bg-zinc-800">
                  <.icon name="hero-arrow-left-on-rectangle-mini" class="w-5 h-5" /> <span>退出登录</span>
                </.link>
              </li>
            </.focus_wrap>
          </ul>
        </div>
      </div>
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def icon_button(assigns) do
    ~H"""
    <button
      class={[
        "inline-flex p-1.5 justify-center items-center hover:bg-zinc-100 rounded-md text-emphasis",
        "dark:hover:bg-zinc-800 dark:hover:text-white transition-colors duration-200 ease-in-out",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end
