defmodule DianWeb.DiaanLiveComponent do
  use DianWeb, :live_component

  import Dian.Helpers

  alias Dian.QQ
  alias Dian.Markdown

  def render(assigns) do
    ~H"""
    <li id={@id} class="w-full">
      <div class="bg-white dark:bg-zinc-900 px-2.5 py-4 flex flex-col gap-4 rounded border border-zinc-200 dark:border-zinc-800">
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
            <span class="text-zinc-700 dark:text-zinc-400">
              <%= @diaan.message.sender.nickname %>
            </span>
            <span class="text-zinc-600 text-xs dark:text-zinc-500">
              <%= format_datetime(@diaan.message.sent_at) %> 发送
            </span>
          </div>
        </header>

        <section id={"#{@id}-content"} class="prose prose-zinc max-w-none dark:prose-invert px-2">
          <.diaan_content :for={item <- @diaan.message.content} item={item} />
        </section>

        <footer class="flex justify-between items-center">
          <span class="text-zinc-600 text-xs dark:text-zinc-500">
            来自 <%= @diaan.message.group.name %>
          </span>

          <span class="text-zinc-600 text-xs dark:text-zinc-500">
            由 <%= @diaan.operator.nickname %> 设置
          </span>
        </footer>
      </div>
    </li>
    """
  end

  defp diaan_content(%{item: %{"type" => "text", "data" => data}} = assigns) do
    assigns = assign(assigns, data: data |> Enum.map(&Markdown.to_html!/1) |> Enum.join(""))

    ~H"""
    <%= raw(@data) %>
    """
  end

  defp diaan_content(%{item: %{"type" => "at", "data" => user}} = assigns) do
    assigns = assign(assigns, user: user)

    ~H"""
    <span class="inline-block mr-2 text-blue-700 dark:text-sky-600 cursor-pointer hover:text-blue-600 dark:hover:text-sky-500 [&+p]:inline-block">
      @<%= @user["nickname"] %>
    </span>
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
      "bg-zinc-50 dark:bg-zinc-800 text-zinc-700 dark:text-zinc-300 text-sm first:mb-2 gap-2"
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
end
