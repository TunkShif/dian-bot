defmodule DianWeb.DiaanLiveComponent do
  use DianWeb, :live_component

  import Dian.Helpers

  alias Dian.QQ

  def render(assigns) do
    ~H"""
    <li id={@id}>
      <div class="bg-white p-2.5 rounded flex flex-col gap-4">
        <header class="flex gap-2">
          <div class="w-11 h-11 rounded-full border border-zinc-50">
            <img
              src={QQ.get_user_avator_by_number(@diaan.message.sender.number)}
              class="w-full h-full aspect-square rounded-full"
            />
          </div>
          <div class="flex flex-col justify-between">
            <span class="text-slate-800"><%= @diaan.message.sender.nickname %></span>
            <span class="text-slate-600 text-xs">
              <%= format_datetime(@diaan.message.sent_at) %> 发送
            </span>
          </div>
        </header>

        <section class="px-2">
          <.diaan_content :for={item <- @diaan.message.content} item={item} />
        </section>

        <footer class="flex justify-between items-center">
          <span class="text-slate-600 text-xs">
            来自 <%= @diaan.message.group.name %>
          </span>

          <span class="text-slate-600 text-xs">
            由 <%= @diaan.operator.nickname %> 设置
          </span>
        </footer>
      </div>
    </li>
    """
  end

  defp diaan_content(%{item: %{"type" => "text", "data" => data}} = assigns) do
    ~H"""
    <p :for={text <- data} class="break-words"><%= text %></p>
    """
  end

  defp diaan_content(%{item: %{"type" => "at", "data" => user}} = assigns) do
    ~H"""
    <span class="inline-block text-blue-700 cursor-pointer hover:text-blue-600">
      @ <%= user["nickname"] %>
    </span>
    """
  end

  defp diaan_content(%{item: %{"type" => "image", "data" => image}} = assigns) do
    ~H"""
    <figure>
      <img src={image["url"]} />
    </figure>
    """
  end

  defp diaan_content(assigns) do
    ~H"""

    """
  end
end
