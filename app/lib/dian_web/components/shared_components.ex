defmodule DianWeb.SharedComponents do
  use DianWeb, :html

  alias Dian.QQ
  alias Dian.Messenger.Group
  alias Dian.Profiles.User, as: Profile

  attr :id, :string, default: "group-select-menu"
  attr :root, :string, default: nil
  attr :popup, :string, default: nil
  attr :selected, Group, default: nil
  attr :groups, :list, required: true
  attr :on_select, JS, required: true

  def group_select(assigns) do
    ~H"""
    <.select_menu
      id={@id}
      root={@root}
      popup={@popup}
      content="max-h-[480px] overflow-y-auto"
      items={@groups}
      selected={@selected}
      on_select={@on_select}
    >
      <:trigger :let={%{attrs: attrs, selected: selected}}>
        <.button class="w-full" {attrs}>
          <:prefix>
            <.icon name="hero-user-group-mini" class="shrink-0 w-4 h-4 text-emphasis" />
          </:prefix>
          <span :if={!selected} class="text-secondary">按群组过滤</span>
          <span :if={selected} class="truncate"><%= "#{selected.name} (#{selected.number})" %></span>
          <.icon name="hero-chevron-up-down-mini" class="w-5 h-5 ml-auto" />
        </.button>
      </:trigger>

      <:extra :let={%{attrs: attrs}}>
        <button
          class="text-sm text-emphasis font-medium text-left w-full px-2 py-1.5 rounded hover:bg-zinc-100 dark:hover:bg-zinc-800"
          phx-value-group_id="nil"
          {attrs}
        >
          全部群组
        </button>
      </:extra>

      <:item :let={%{attrs: attrs, item: item}}>
        <button
          class="text-sm text-emphasis font-medium text-left w-full px-2 py-1.5 rounded hover:bg-zinc-100 dark:hover:bg-zinc-800"
          phx-value-group_id={item.id}
          {attrs}
        >
          <span class="truncate">
            <%= "#{item.name} (#{item.number})" %>
          </span>
        </button>
      </:item>
    </.select_menu>
    """
  end

  attr :id, :string, default: "user-profile-select-menu"
  attr :root, :string, default: nil
  attr :popup, :string, default: nil
  attr :selected, Profile, default: nil
  attr :profiles, :list, required: true
  attr :on_select, JS, required: true

  def profile_select(assigns) do
    ~H"""
    <.select_menu
      id={@id}
      root={@root}
      popup={@popup}
      content="max-h-[480px] overflow-y-auto"
      items={@profiles}
      selected={@selected}
      on_select={@on_select}
    >
      <:trigger :let={%{attrs: attrs, selected: selected}}>
        <.button class="w-full truncate" {attrs}>
          <:prefix>
            <.icon name="hero-user-mini" class="shrink-0 w-4 h-4 text-emphasis" />
          </:prefix>
          <span :if={!selected} class="text-secondary">按成员过滤</span>
          <span :if={selected} class="truncate">
            <%= "#{selected.nickname} (#{selected.number})" %>
          </span>
          <.icon name="hero-chevron-up-down-mini" class="w-5 h-5 ml-auto" />
        </.button>
      </:trigger>

      <:extra :let={%{attrs: attrs}}>
        <button
          class="text-sm text-emphasis font-medium text-left w-full px-2 py-1.5 rounded hover:bg-zinc-100 dark:hover:bg-zinc-800"
          phx-value-profile_id="nil"
          {attrs}
        >
          全部成员
        </button>
      </:extra>

      <:item :let={%{attrs: attrs, item: item}}>
        <button
          class="inline-flex items-center gap-2 text-sm text-emphasis font-medium text-left w-full px-2 py-1.5 rounded hover:bg-zinc-100 dark:hover:bg-zinc-800"
          phx-value-profile_id={item.id}
          {attrs}
        >
          <div class="w-7 h-7 rounded-full border border-zinc-900/10">
            <img
              src={QQ.get_user_avator_by_number(item.number)}
              loading="lazy"
              alt="just an avatar image, most probably a picture of anime waifu"
              class="w-full h-full aspect-square rounded-full animate__faster"
              phx-mounted={JS.dispatch("poke:mounted")}
              phx-remove={JS.dispatch("poke:removed")}
            />
          </div>

          <div class="flex gap-0.5">
            <span class="truncate">
              <%= item.nickname %>
            </span>
            <span>
              <%= "(#{item.number})" %>
            </span>
          </div>
        </button>
      </:item>
    </.select_menu>
    """
  end
end
