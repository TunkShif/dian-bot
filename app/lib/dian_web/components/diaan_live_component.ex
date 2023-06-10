defmodule DianWeb.DiaanLiveComponent do
  use DianWeb, :live_component

  import Dian.Helpers

  alias Dian.QQ

  def render(assigns) do
    ~H"""
    <li id={@id}>
      <div class="bg-white dark:bg-zinc-900 px-2.5 py-4 flex flex-col gap-4 rounded border border-zinc-200 dark:border-zinc-800">
        <header class="flex gap-2">
          <div class="w-11 h-11 rounded-full border border-zinc-900/10">
            <img
              src={QQ.get_user_avator_by_number(@diaan.message.sender.number)}
              class="w-full h-full aspect-square rounded-full"
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

        <section class="px-2">
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
    assigns = assign(assigns, data: data)

    ~H"""
    <p :for={text <- @data} class="break-words text-zinc-700 dark:text-zinc-400"><%= text %></p>
    """
  end

  defp diaan_content(%{item: %{"type" => "at", "data" => user}} = assigns) do
    assigns = assign(assigns, user: user)

    ~H"""
    <span class="inline-block text-blue-700 dark:text-sky-600 cursor-pointer hover:text-blue-600 dark:hover:text-sky-500 [&+p]:inline-block [&+p]:ml-2">
      @<%= @user["nickname"] %>
    </span>
    """
  end

  defp diaan_content(%{item: %{"type" => "image", "data" => image}} = assigns) do
    assigns = assign(assigns, image: image)

    ~H"""
    <figure>
      <img src={@image["url"]} />
    </figure>
    """
  end

  defp diaan_content(assigns) do
    ~H"""

    """
  end
end
