defmodule DianWeb.ErrorJSON do
  def render("401.json", _assigns) do
    %{errors: %{detail: "Unauthorized"}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: "Resouce Not Found"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal Server Error"}}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
