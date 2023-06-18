defmodule DianWeb.LoginLive do
  use DianWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class=""></div>
    """
  end
end
