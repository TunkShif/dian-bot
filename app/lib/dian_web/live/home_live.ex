defmodule DianWeb.HomeLive do
  use DianWeb, :live_view

  import DianWeb.HomeComponents
  import DianWeb.SharedComponents

  alias Dian.Profiles
  alias Dian.Favorites
  alias Dian.Messenger
  alias Dian.Statistics
  alias Dian.Accounts.User

  alias DianWeb.Presence

  def mount(_params, _session, socket) do
    if connected?(socket) do
      subscribe_all()
    end

    {:ok,
     socket
     |> assign(keyword: nil)
     |> load_profiles()
     |> load_groups()
     |> load_diaans()
     |> load_hotwords()
     |> load_presence()}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center gap-4">
      <section class="grid grid-rows-2 md:grid-rows-1 grid-cols-2 gap-4 w-full md:w-[720px]">
        <div class="col-span-2">
          <.search_panel keyword={@keyword} hotwords={@hotwords} />
        </div>
        <div>
          <.group_select
            root="w-full"
            popup="mt-2"
            groups={@groups}
            selected={@selected_group}
            on_select={JS.push("select:group")}
          />
        </div>
        <div>
          <.profile_select
            root="w-full"
            popup="mt-2 right-2.5 md:right-auto"
            profiles={@profiles}
            selected={@selected_profile}
            on_select={JS.push("select:profile")}
          />
        </div>
      </section>

      <section class="w-full md:w-[720px]">
        <ul id="diaans-list" phx-update="stream" class="mx-auto w-full flex flex-col gap-4">
          <.diaan_card
            :for={{dom_id, diaan} <- @streams.diaans}
            id={dom_id}
            diaan={diaan}
            with_menu={User.is_admin?(@current_user)}
          />
        </ul>
      </section>

      <section class="w-full flex justify-center items-center">
        <.button :if={@cursor} phx-click="load:more" has_spinner>
          <span class="inline-block phx-click-loading:hidden"> 多来点 </span>
          <span class="hidden phx-click-loading:inline-block"> 加载中... </span>
        </.button>
        <p :if={@cursor == nil} class="text-xs text-right text-primary">
          已经到底了别翻了
        </p>
      </section>

      <section class="w-full my-4 flex justify-end items-center">
        <div class="inline-flex justify-center items-center gap-2">
          <span class="relative flex justify-center items-center h-2 w-2">
            <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75">
            </span>
            <span class="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
          </span>
          <p class="text-xs text-right text-primary">
            现在一共有 <span class="text-emphasis font-medium"><%= @online_count %></span> 人在翻阅合订本
          </p>
        </div>
      </section>
    </div>

    <.at_popup_template />
    """
  end

  defp subscribe_all() do
    Presence.subscribe()
    Presence.join()
    Favorites.subscribe()
    Statistics.subscribe("hotword")
  end

  defp load_diaans(socket, opts \\ []) do
    reset = opts[:reset]
    cursor = socket.assigns[:cursor]
    group = socket.assigns[:selected_group]
    profile = socket.assigns[:selected_profile]
    keyword = socket.assigns[:keyword]

    {diaans, %{after: cursor}} =
      Favorites.list_favorites_diaans(cursor, %{
        "group_id" => group && group.id,
        "sender_id" => profile && profile.id,
        "keyword" => keyword
      })

    socket
    |> assign(cursor: cursor)
    |> stream(:diaans, diaans, reset: reset)
  end

  defp load_hotwords(socket) do
    hotwords = Statistics.list_hotwords() |> Enum.map(& &1.keyword)

    socket
    |> assign(hotwords: hotwords)
  end

  defp load_groups(socket) do
    groups = Messenger.list_messenger_groups()
    assign(socket, groups: groups, selected_group: nil)
  end

  defp load_profiles(socket) do
    profiles = Profiles.list_profiles_users()
    assign(socket, profiles: profiles, selected_profile: nil)
  end

  defp load_presence(socket) do
    assign(socket, online_count: Presence.count())
  end

  def handle_event("load:more", _parms, socket) do
    {:noreply, load_diaans(socket)}
  end

  def handle_event("select:group", %{"group_id" => group_id}, socket) do
    selected_group = socket.assigns.groups |> Enum.find(&("#{&1.id}" === group_id))

    {:noreply,
     socket
     |> assign(selected_group: selected_group, cursor: nil)
     |> load_diaans(reset: true)}
  end

  def handle_event("select:profile", %{"profile_id" => profile_id}, socket) do
    selected_profile = socket.assigns.profiles |> Enum.find(&("#{&1.id}" === profile_id))

    {:noreply,
     socket
     |> assign(selected_profile: selected_profile, cursor: nil)
     |> load_diaans(reset: true)}
  end

  def handle_event("submit:search", %{"keyword" => keyword}, socket) do
    keyword = String.trim(keyword)

    socket =
      unless keyword == "" do
        Statistics.create_hotword(%{keyword: keyword})
        socket |> assign(keyword: keyword, cursor: nil) |> load_diaans(reset: true)
      else
        socket
      end

    {:noreply, socket}
  end

  def handle_event("delete:" <> id, _params, socket) do
    Favorites.get_diaan!(id)
    |> Favorites.delete_diaan()

    {:noreply, socket}
  end

  def handle_info(%{topic: "joined", event: "presence_diff"}, socket) do
    {:noreply, socket |> assign(online_count: Presence.count())}
  end

  def handle_info({:added, diaan}, socket) do
    {:noreply, socket |> stream_insert(:diaans, diaan, at: 0)}
  end

  def handle_info({:deleted, diaan}, socket) do
    {:noreply, socket |> stream_delete(:diaans, diaan) |> put_flash(:info, "删除成功")}
  end

  def handle_info("update:hotwords", socket) do
    {:noreply, load_hotwords(socket)}
  end
end
