defmodule DianWeb.LoginLive do
  use DianWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(form: to_form(%{"qq_number" => "", "password" => ""}, as: "user"))}
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-center items-center h-auto md:h-[calc(100vh-0.25rem*22)]">
      <div class="card-primary p-4 md:px-6 w-full mx-2 md:w-[712px]">
        <header class="flex flex-col gap-1 md:gap-2">
          <h2 class="text-emphasis text-lg md:text-2xl font-semibold">登录账号</h2>
          <p class="text-sm">欢迎来到提瓦特大陆</p>
        </header>

        <.form for={@form} action={~p"/users/login"}>
          <main class="mt-4 space-y-4">
            <div class="flex flex-col gap-2">
              <h3 class="text-primary md:text-lg font-medium">输入你的企鹅帐号</h3>
              <input
                id={@form[:qq_number].id}
                name={@form[:qq_number].name}
                value={@form[:qq_number].value}
                required
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
              <h3 class="text-primary md:text-lg font-medium">输入你的本站密码</h3>
              <input
                id={@form[:password].id}
                type="password"
                name={@form[:password].name}
                value={Phoenix.HTML.Form.normalize_value("password", @form[:password].value)}
                required
                class={[
                  "inline-flex md:w-2/3 px-2.5 py-1.5 text-sm text-zinc-700 dark:text-zinc-50 font-medium rounded-md shadow-sm",
                  "bg-white dark:bg-zinc-900 hover:bg-zinc-50 disabled:bg-white focus:outline-none",
                  "border-none ring-1 ring-inset ring-zinc-300 dark:ring-zinc-700 focus:ring-0",
                  "focus-visible:ring-2 focus-visible:ring-zinc-500 dark:focus-visible:ring-zinc-400",
                  "transition-colors duration-200 ease-in-out"
                ]}
              />
            </div>
          </main>

          <footer class="mt-4 flex justify-end items-center">
            <.input field={@form[:remember_me]} type="checkbox" label="保持登录状态" />
            <.button type="submit" class="ml-auto">登录</.button>
          </footer>
        </.form>
      </div>
    </div>
    """
  end
end
