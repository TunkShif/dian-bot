defmodule DianWeb.HomeComponents do
  use DianWeb, :html

  import Dian.Helpers

  alias Dian.QQ
  alias Dian.Markdown
  alias Dian.Favorites.Diaan

  attr :id, :string, required: true
  attr :diaan, Diaan, required: true
  attr :with_menu, :boolean, default: false

  def diaan_card(assigns) do
    ~H"""
    <li id={@id} class="w-full">
      <div class="card-primary relative px-2.5 py-4 flex flex-col gap-4">
        <header class="flex gap-2">
          <div class="w-11 h-11 rounded-full border border-zinc-900/10">
            <img
              src={QQ.get_user_avator_by_number(@diaan.message.sender.number)}
              loading="lazy"
              alt="just an avatar image, most probably a picture of anime waifu"
              class="w-full h-full aspect-square rounded-full animate__faster"
              phx-mounted={JS.dispatch("poke:mounted")}
              phx-remove={JS.dispatch("poke:removed")}
            />
          </div>

          <div class="flex flex-col justify-between">
            <span class="text-emphasis">
              <%= @diaan.message.sender.nickname %>
            </span>
            <span class="text-primary text-xs">
              <%= format_datetime(@diaan.message.sent_at) %> 发送
            </span>
          </div>

          <.action_menu :if={@with_menu} id={@id} />
        </header>

        <section
          id={"#{@id}-content"}
          class="prose prose-zinc max-w-none break-words dark:prose-invert px-2"
        >
          <.diaan_content :for={item <- @diaan.message.content} id={@id} item={item} />
        </section>

        <footer class="flex justify-between items-center">
          <span class="text-primary text-xs">
            来自 <%= @diaan.message.group.name %>
          </span>

          <span class="text-primary text-xs">
            由 <%= @diaan.operator.nickname %> 设置
          </span>
        </footer>
      </div>

      <.confirm_modal id={@id} diaan={@diaan} />
    </li>
    """
  end

  def at_popup_template(assigns) do
    ~H"""
    <template id="at-popup-template">
      <div class="card-emphasis px-2 py-1.5">
        <div class="flex gap-2 items-center">
          <div class="w-11 h-11 rounded-full border border-zinc-900/10">
            <img
              data-avatar
              loading="lazy"
              alt="just an avatar image, most probably a picture of anime waifu"
              class="w-full h-full aspect-square rounded-full animate__faster"
            />
          </div>

          <div class="flex gap-1.5">
            <span class="text-emphasis" data-nickname></span>
            <span class="text-secondary" data-number></span>
          </div>
        </div>
      </div>
    </template>
    """
  end

  defp diaan_content(%{item: %{"type" => "text", "data" => data}} = assigns) do
    assigns = assign(assigns, data: data |> Enum.join("\n\n") |> Markdown.to_html!())

    ~H"""
    <%= raw(@data) %>
    """
  end

  defp diaan_content(%{item: %{"type" => "at", "data" => user}} = assigns) do
    assigns = assign(assigns, user: user)

    ~H"""
    <button
      phx-mounted={JS.dispatch("at-popup:mounted")}
      phx-remove={JS.dispatch("at-popup:removed")}
      data-avatar-url={QQ.get_user_avator_by_number(@user["number"])}
      data-user-nickname={@user["nickname"]}
      data-user-number={@user["number"]}
      class="not-prose inline-block [&+p]:inline-block mr-2 text-blue-700 dark:text-sky-600 cursor-pointer hover:text-blue-600 dark:hover:text-sky-500"
    >
      @<%= @user["nickname"] %>
    </button>
    """
  end

  defp diaan_content(%{item: %{"type" => "image", "data" => image}} = assigns) do
    assigns = assign(assigns, image: image)

    ~H"""
    <figure>
      <img
        src={@image["url"]}
        loading="lazy"
        alt="just a meme, but sorry I can't describe the picture"
      />
    </figure>
    """
  end

  defp diaan_content(%{item: %{"type" => type}} = assigns) do
    assigns = assign(assigns, type: type)

    ~H"""
    <div class={[
      "flex items-center pl-4 py-3 rounded-md border border-zinc-200 dark:border-zinc-700",
      "bg-zinc-50 dark:bg-zinc-800 text-emphasis text-sm first:mb-2 gap-2"
    ]}>
      <span class="inline-flex items-center align-text-top text-emerald-600">
        <.icon name="hero-question-mark-circle-mini" class="w-4 h-4" />
      </span>
      <span>显示不了特殊类型消息: </span>
      <code class="inline bg-white dark:bg-zinc-900 px-1.5 rounded border border-zinc-200 dark:border-zinc-800">
        <%= @type %>
      </code>
    </div>
    """
  end

  defp action_menu(assigns) do
    ~H"""
    <.popup
      :let={api}
      id={"#{@id}-action-menu"}
      class="top-10 right-0"
      root="absolute top-1.5 right-1.5"
    >
      <:trigger :let={attrs}>
        <.icon_button {attrs}>
          <.icon name="hero-ellipsis-vertical-mini" class="w-5 h-5" />
        </.icon_button>
      </:trigger>

      <div class="card-emphasis w-44 px-1.5 py-2">
        <ul class="w-full flex flex-col text-primary text-sm">
          <.focus_wrap id={"#{@id}-action-menu-focus-wrap"}>
            <li class="w-full">
              <button
                phx-click={api.hide |> JS.dispatch("dialog:show", to: "##{@id}-confirm-modal")}
                class="w-full flex items-center px-1 py-1.5 gap-1.5 rounded hover:bg-zinc-100 dark:hover:bg-zinc-800 text-rose-600 dark:text-rose-500"
              >
                <.icon name="hero-trash-solid" class="w-5 h-5" />
                <span>删除</span>
              </button>
            </li>
          </.focus_wrap>
        </ul>
      </div>
    </.popup>
    """
  end

  defp confirm_modal(assigns) do
    ~H"""
    <dialog id={"#{@id}-confirm-modal"} class="fixed inset-0 flex justify-center items-center">
      <div
        class="card-emphasis relative mx-4 px-4 py-3 w-full md:w-96"
        phx-click-away={JS.dispatch("dialog:hide", to: "##{@id}-confirm-modal")}
      >
        <header class="flex items-center">
          <.icon
            name="hero-exclamation-circle-mini"
            class="w-6 h-6 mr-2 text-rose-700 dark:text-rose-600"
          />
          <h2 class="text-emphasis">警告</h2>

          <button
            phx-click={JS.dispatch("dialog:hide", to: "##{@id}-confirm-modal")}
            class="absolute top-2 right-2 inline-flex justify-center items-center p-0.5 rounded-full hover:bg-zinc-100 dark:hover:bg-zinc-800 transition-colors duration-200 ease-in-out"
          >
            <.icon name="hero-x-mark-mini" class="w-5 h-5" />
          </button>
        </header>

        <p class="text-sm text-secondary my-3">
          确定要删除这条内容吗?
          删了就再也找不回来了
        </p>

        <footer class="flex justify-end">
          <.button phx-click={
            JS.dispatch("dialog:hide", to: "##{@id}-confirm-modal")
            |> JS.push("delete:#{@diaan.id}")
          }>
            确定
          </.button>
        </footer>
      </div>
    </dialog>
    """
  end

  def search_panel(assigns) do
    ~H"""
    <.button class="w-full" phx-click={JS.dispatch("dialog:show", to: "#search-panel-dialog")}>
      <:prefix>
        <.icon name="hero-magnifying-glass-mini" class="w-4 h-4" />
      </:prefix>
      <span :if={@keyword} class="truncate">
        <%= @keyword %>
      </span>
      <span :if={!@keyword} class="text-secondary">
        按关键字搜索
      </span>
    </.button>

    <dialog id="search-panel-dialog" class="fixed inset-0 flex justify-center items-center">
      <div
        class="card-emphasis mx-4 w-full md:w-[512px] h-96 flex flex-col rounded-lg"
        phx-click-away={JS.dispatch("dialog:hide", to: "#search-panel-dialog")}
      >
        <header class="flex items-center w-full p-4 gap-2 border-b border-zinc-200 dark:border-zinc-800">
          <.icon name="hero-magnifying-glass-mini" class="w-5 h-5 text-emphasis" />
          <form
            class="w-full"
            phx-submit={
              JS.push("submit:search") |> JS.dispatch("dialog:hide", to: "#search-panel-dialog")
            }
          >
            <input
              name="keyword"
              class="inline-flex w-full bg-transparent outline-none truncate"
              placeholder="输入关键字来查找精华消息"
            />
          </form>
        </header>

        <h3 class="flex items-center p-4 gap-2 border-b border-zinc-200 dark:border-zinc-800">
          <.icon name="hero-fire-mini" class="w-5 h-5 text-red-600 dark:text-red-700" />
          <span class="text-primary">大家都在搜</span>
        </h3>

        <div class="overflow-y-auto">
          <ul class="flex flex-col divide-y divide-zinc-200 dark:divide-zinc-800">
            <li :for={hotword <- @hotwords}>
              <button
                class="w-full p-4 text-left truncate hover:bg-zinc-50 dark:hover:bg-zinc-800"
                phx-value-keyword={hotword}
                phx-click={
                  JS.push("submit:search") |> JS.dispatch("dialog:hide", to: "#search-panel-dialog")
                }
              >
                <span class="text-sm font-medium text-emphasis">
                  <%= hotword %>
                </span>
              </button>
            </li>
          </ul>
        </div>
      </div>
    </dialog>
    """
  end
end
