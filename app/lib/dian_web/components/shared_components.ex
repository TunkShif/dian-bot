defmodule DianWeb.SharedComponents do
  use DianWeb, :html

  alias Dian.Messenger.Group

  attr :class, :string, default: ""
  attr :selected, Group, default: nil
  attr :groups, :list, required: true
  attr :on_select, JS, required: true

  def group_select(assigns) do
    ~H"""
    <.popup :let={api} id="group-select" class="mt-2" root={@class}>
      <:trigger :let={attrs}>
        <.button class="w-full" {attrs}>
          <:prefix>
            <.icon name="hero-user-group-mini" class="w-4 h-4 text-emphasis" />
          </:prefix>
          <span :if={!@selected} class="text-secondary">按群组过滤</span>
          <span :if={@selected}><%= "#{@selected.name} (#{@selected.number})" %></span>
          <.icon name="hero-chevron-up-down-mini" class="w-5 h-5 ml-auto" />
        </.button>
      </:trigger>

      <div class="card-emphasis w-auto px-1.5 py-2">
        <ul class="w-full flex flex-col text-primary">
          <.focus_wrap id="groups-select-focus-wrap">
            <li :for={group <- @groups} class="w-full text-sm text-emphasis font-medium">
              <button
                phx-value-group_id={group.id}
                data-on-select={@on_select}
                phx-click={api.hide |> JS.exec("data-on-select")}
                class="text-left w-full px-2 py-1.5 rounded hover:bg-zinc-100 dark:hover:bg-zinc-800"
              >
                <%= "#{group.name} (#{group.number})" %>
              </button>
            </li>
          </.focus_wrap>
        </ul>
      </div>
    </.popup>
    """
  end
end
