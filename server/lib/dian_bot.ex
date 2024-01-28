defmodule DianBot do
  @adapter Application.compile_env!(:dian, DianBot) |> Keyword.get(:adapter)

  defdelegate is_online(), to: @adapter

  defdelegate get_message(mid), to: @adapter
  defdelegate get_forwarded_messages(mid), to: @adapter

  defdelegate get_user(uid), to: @adapter
  defdelegate get_group(gid), to: @adapter

  defdelegate send_group_message(gid, content), to: @adapter
  defdelegate set_honorable_message(mid), to: @adapter
end
