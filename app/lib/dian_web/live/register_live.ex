defmodule DianWeb.RegisterLive do
  use DianWeb, :live_view

  alias Dian.QQ
  alias Dian.Messenger
  alias Dian.Accounts
  alias Dian.Profiles

  @validation_timeout 2 * 60 * 1000

  def mount(_params, _session, socket) do
    groups = Messenger.list_messenger_groups()
    selected_group = List.first(groups)

    # "input_number" -> "validating" -> "setting_password"
    step = "input_number"

    {:ok,
     assign(socket,
       step: step,
       groups: groups,
       input: %{
         "group" => selected_group,
         "qq_number" => "",
         "validation_code" => ""
       }
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-center items-center h-auto md:h-[calc(100vh-0.25rem*22)]">
      <div class="card-primary p-4 md:px-6 w-full mx-2 md:w-[712px]">
        <%= unless @step == "setting_password" do %>
          <.input_number_form {assigns} />
        <% else %>
          <.setting_password_form {assigns} />
        <% end %>
      </div>
    </div>
    """
  end

  defp input_number_form(assigns) do
    ~H"""
    <div>
      <.form_header />

      <div class="flex flex-col gap-2">
        <h3 class="text-primary md:text-lg font-medium">选择你的群组</h3>

        <.popup :let={api} id="group-select" class="mt-2">
          <:trigger :let={attrs}>
            <.button class="w-full md:w-2/3" disabled={@step != "input_number"} {attrs}>
              <span><%= "#{@input["group"].name} (#{@input["group"].number})" %></span>
              <.icon name="hero-chevron-up-down-mini" class="w-5 h-5 ml-auto" />
            </.button>
          </:trigger>

          <div class="card-emphasis w-auto px-1.5 py-2">
            <ul class="w-full flex flex-col text-primary">
              <.focus_wrap id="groups-select-focus-wrap">
                <li :for={group <- @groups} class="w-full text-sm text-emphasis font-medium">
                  <button
                    phx-value-group_id={group.id}
                    phx-click={
                      api.hide
                      |> JS.push("change:selected_group")
                    }
                    class="text-left w-full px-2 py-1.5 rounded hover:bg-zinc-100 dark:hover:bg-zinc-800"
                  >
                    <%= "#{group.name} (#{group.number})" %>
                  </button>
                </li>
              </.focus_wrap>
            </ul>
          </div>
        </.popup>
      </div>

      <form
        phx-change="change:input"
        phx-submit={
          if(@step == "input_number", do: "next:send_validation_code", else: "next:set_password")
        }
      >
        <main class="mt-4 relative space-y-4">
          <div class="flex flex-col gap-2">
            <h3 class="text-primary md:text-lg font-medium">输入你的企鹅账号</h3>
            <input
              type="text"
              name="qq_number"
              pattern="\d+"
              value={@input["qq_number"]}
              required
              disabled={@step != "input_number"}
              phx-blur={JS.set_attribute({"data-validating", "true"}, to: "[data-validating]")}
              phx-debounce="blur"
              class={[
                "peer inline-flex md:w-2/3 px-2.5 py-1.5 text-sm text-zinc-700 dark:text-zinc-50 font-medium rounded-md shadow-sm",
                "bg-white dark:bg-zinc-900 hover:bg-zinc-50 disabled:bg-white focus:outline-none",
                "border-none ring-1 ring-inset ring-zinc-300 dark:ring-zinc-700 focus:ring-0",
                "focus-visible:ring-2 focus-visible:ring-zinc-500 dark:focus-visible:ring-zinc-400",
                "disabled:opacity-60 disabled:cursor-not-allowed",
                "transition-colors duration-200 ease-in-out"
              ]}
            />
            <p
              data-validating="false"
              class="hidden data-[validating=false]:!hidden peer-invalid:block text-sm text-red-500"
            >
              你要不要看看你在输些什么
            </p>
          </div>

          <div :if={@step == "validating"} class="flex flex-col gap-2">
            <h3 class="text-primary md:text-lg font-medium">输入你收到的神秘代码</h3>
            <input
              type="text"
              name="validation_code"
              value={@input["validation_code"]}
              required
              phx-debounce="blur"
              class={[
                "inline-flex md:w-2/3 px-2.5 py-1.5 text-sm text-zinc-700 dark:text-zinc-50 font-medium rounded-md shadow-sm",
                "bg-white dark:bg-zinc-900 hover:bg-zinc-50 disabled:bg-white focus:outline-none",
                "border-none ring-1 ring-inset ring-zinc-300 dark:ring-zinc-700 focus:ring-0",
                "focus-visible:ring-2 focus-visible:ring-zinc-500 dark:focus-visible:ring-zinc-400",
                "transition-colors duration-200 ease-in-out"
              ]}
            />
            <p class="text-sm">请在两分钟内填入你在 QQ 上收到的代码</p>
          </div>
        </main>

        <footer class="mt-4 flex justify-end">
          <.button type="submit">下一步</.button>
        </footer>
      </form>
    </div>
    """
  end

  defp setting_password_form(assigns) do
    ~H"""
    <div>
      <.form_header />

      <div class="mt-4 flex gap-4">
        <div class="w-14 h-14 rounded-full border border-zinc-900/10">
          <img
            src={QQ.get_user_avator_by_number(@profile.number)}
            loading="lazy"
            alt="just an avatar image, most probably a picture of anime waifu"
            class="w-full h-full aspect-square rounded-full animate__faster"
            phx-mounted={JS.dispatch("poke:mounted")}
            phx-remove={JS.dispatch("poke:removed")}
          />
        </div>

        <div class="flex flex-col justify-around">
          <h3 class="text-lg text-primary font-medium tracking-wide">
            Bonjour 啊, <%= @profile.nickname %>!
          </h3>
          <p class="text-sm text-secondary">
            企鹅账号为 <span class="text-primary px-0.5"><%= @profile.number %></span> 的旅行者
          </p>
        </div>
      </div>

      <.form for={@form} phx-change="validate:user" phx-submit="submit:user">
        <main class="mt-4 space-y-4">
          <div class="flex flex-col gap-2">
            <h3 class="text-primary md:text-lg font-medium">给账号设个密码</h3>
            <input
              id={@form[:password].id}
              type="password"
              name={@form[:password].name}
              value={Phoenix.HTML.Form.normalize_value("password", @form[:password].value)}
              minlength="10"
              maxlength="72"
              required
              phx-debounce="blur"
              class={[
                "inline-flex md:w-2/3 px-2.5 py-1.5 text-sm text-zinc-700 dark:text-zinc-50 font-medium rounded-md shadow-sm",
                "bg-white dark:bg-zinc-900 hover:bg-zinc-50 disabled:bg-white focus:outline-none",
                "border-none ring-1 ring-inset ring-zinc-300 dark:ring-zinc-700 focus:ring-0",
                "focus-visible:ring-2 focus-visible:ring-zinc-500 dark:focus-visible:ring-zinc-400",
                "transition-colors duration-200 ease-in-out"
              ]}
            />
          </div>

          <div class="flex flex-col gap-2">
            <h3 class="text-primary md:text-lg font-medium">再输一遍密码</h3>
            <input
              id={@form[:password_confirmation].id}
              type="password"
              name={@form[:password_confirmation].name}
              value={
                Phoenix.HTML.Form.normalize_value("password", @form[:password_confirmation].value)
              }
              minlength="10"
              maxlength="72"
              required
              phx-debounce="blur"
              class={[
                "inline-flex md:w-2/3 px-2.5 py-1.5 text-sm text-zinc-700 dark:text-zinc-50 font-medium rounded-md shadow-sm",
                "bg-white dark:bg-zinc-900 hover:bg-zinc-50 disabled:bg-white focus:outline-none",
                "border-none ring-1 ring-inset ring-zinc-300 dark:ring-zinc-700 focus:ring-0",
                "focus-visible:ring-2 focus-visible:ring-zinc-500 dark:focus-visible:ring-zinc-400",
                "transition-colors duration-200 ease-in-out"
              ]}
            />
            <p
              :if={Enum.count(@form[:password_confirmation].errors) !== 0}
              phx-feedback-for="password_confirmation"
              class="phx-no-feedback:hidden text-sm text-red-500"
            >
              两次输入的密码不一样啦
            </p>
          </div>
        </main>

        <footer class="mt-4 flex justify-end">
          <.button type="submit">好了</.button>
        </footer>
      </.form>
    </div>
    """
  end

  defp form_header(assigns) do
    ~H"""
    <header class="flex flex-col gap-1 md:gap-2">
      <h2 class="text-emphasis text-lg md:text-2xl font-semibold">绑定账号</h2>
      <p class="text-sm">你将绑定你的企鹅账号，扮演一位名为“旅行者”的神秘角色</p>
    </header>
    """
  end

  def handle_event("change:selected_group", %{"group_id" => group_id}, socket) do
    group = Messenger.get_group!(group_id)
    input = %{socket.assigns.input | "group" => group}
    {:noreply, assign(socket, input: input)}
  end

  def handle_event("change:input", params, socket) do
    input = %{
      socket.assigns.input
      | "qq_number" => params["qq_number"] || socket.assigns.input["qq_number"],
        "validation_code" => params["validation_code"] || ""
    }

    {:noreply, assign(socket, input: input)}
  end

  def handle_event("next:send_validation_code", _params, socket) do
    # TODO: error handling
    profile = Profiles.get_or_create_user(socket.assigns.input["qq_number"])

    if profile.user_id do
      {:noreply, socket |> put_flash(:info, "已经绑定过了，快去登录吧!") |> redirect(to: ~p"/users/login")}
    else
      validation_code = Nanoid.generate()

      case QQ.send_private_message(
             socket.assigns.input["qq_number"],
             socket.assigns.input["group"].number,
             "你的绑定神秘代码是：#{validation_code}（2 分钟内有效）"
           ) do
        {:ok, _response} ->
          Process.send_after(self(), "invalidate", @validation_timeout)

          {:noreply,
           socket
           |> assign(step: "validating", validation_code: validation_code, profile: profile)
           |> put_flash(:info, "注意查收你的神秘代码")}

        {:error, _reason} ->
          {:noreply, socket |> put_flash(:error, "哎呀，出错了，重新试试")}
      end
    end
  end

  def handle_event("next:set_password", _params, socket) do
    socket =
      if socket.assigns.validation_code == socket.assigns.input["validation_code"] do
        assign(socket,
          step: "setting_password",
          validation_code: nil,
          form: Accounts.User.registration_changeset(%Accounts.User{}, %{}) |> to_form()
        )
      else
        socket
        |> put_flash(:error, "验证码错了")
        |> redirect(to: ~p"/users/register")
      end

    {:noreply, socket}
  end

  def handle_event("validate:user", %{"user" => params}, socket) do
    form =
      Accounts.User.registration_changeset(%Accounts.User{}, params)
      |> Map.put(:action, :insert)
      |> to_form()

    {:noreply, socket |> assign(form: form)}
  end

  def handle_event("submit:user", %{"user" => params}, socket) do
    qq_number = socket.assigns.input["qq_number"]

    socket =
      case Accounts.register_user(params, qq_number) do
        {:ok, _user} ->
          socket |> put_flash(:info, "注册成功啦，快去登录吧!") |> redirect(to: ~p"/users/login")

        {:error, _reason} ->
          socket |> put_flash(:error, "呃呃呃，出错了。。。") |> redirect(to: ~p"/users/register")
      end

    {:noreply, socket}
  end

  def handle_info("invalidate", socket) do
    {:noreply, socket |> put_flash(:error, "超时了，重新注册") |> redirect(to: ~p"/users/register")}
  end
end
