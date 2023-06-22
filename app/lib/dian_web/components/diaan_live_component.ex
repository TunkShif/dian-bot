defmodule DianWeb.DiaanLiveComponent do
  use DianWeb, :live_component

  import Dian.Helpers

  alias Dian.QQ
  alias Dian.Markdown

  def mount(socket) do
    {:ok, socket |> assign(show_popup: nil)}
  end

  def render(assigns) do
    ~H"""
    <li id={@id} class="w-full">
      <div class="card-primary px-2.5 py-4 flex flex-col gap-4">
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
        </header>

        <section
          id={"#{@id}-content"}
          class="prose prose-zinc max-w-none break-words dark:prose-invert px-2"
        >
          <.diaan_content
            :for={item <- @diaan.message.content}
            id={@id}
            item={item}
            show_popup={@show_popup}
            myself={@myself}
          />
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
    </li>
    """
  end

  defp diaan_content(%{item: %{"type" => "text", "data" => data}} = assigns) do
    assigns = assign(assigns, data: data |> Enum.join("\n\n") |> Markdown.to_html!())

    ~H"""
    <%= raw(@data) %>
    """
  end

  defp diaan_content(%{item: %{"type" => "at", "data" => user}} = assigns) do
    popup_id = "#{assigns.id}-#{user["number"]}"
    assigns = assign(assigns, user: user, popup_id: popup_id)

    ~H"""
    <.popup
      id={@popup_id}
      mount={@show_popup == @popup_id}
      on_show={JS.push("popup:#{popup_id}", target: @myself)}
      on_hide={JS.push("popup:reset", target: @myself)}
      class=""
      root="not-prose inline-block [&+p]:inline-block mr-2"
      show
    >
      <:trigger :let={attrs}>
        <button
          class="text-blue-700 dark:text-sky-600 cursor-pointer hover:text-blue-600 dark:hover:text-sky-500"
          {attrs}
        >
          @<%= @user["nickname"] %>
        </button>
      </:trigger>

      <div class="card-emphasis px-2 py-1.5">
        <div class="flex gap-2 items-center">
          <div class="w-11 h-11 rounded-full border border-zinc-900/10">
            <img
              src={QQ.get_user_avator_by_number(@user["number"])}
              loading="lazy"
              alt="just an avatar image, most probably a picture of anime waifu"
              class="w-full h-full aspect-square rounded-full animate__faster"
              phx-mounted={JS.dispatch("poke:mounted")}
              phx-remove={JS.dispatch("poke:removed")}
            />
          </div>

          <div class="flex gap-1.5">
            <span class="text-emphasis"><%= @user["nickname"] %></span>
            <span class="text-secondary">(<%= @user["number"] %>)</span>
          </div>
        </div>
      </div>
    </.popup>
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

  def handle_event("popup:reset", _params, socket) do
    {:noreply, socket |> assign(show_popup: nil)}
  end

  def handle_event("popup:" <> popup_id, _params, socket) do
    {:noreply, socket |> assign(show_popup: popup_id)}
  end
end
