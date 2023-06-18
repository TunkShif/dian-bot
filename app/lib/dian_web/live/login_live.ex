defmodule DianWeb.LoginLive do
  use DianWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="grid place-items-center">
      <div class="card-primary p-4 md:px-6 w-full mx-2 md:w-[712px]">
        还没写好呢
      </div>
    </div>
    """
  end
end
