defmodule Dian.Accounts.UserNotifier do
  import Swoosh.Email

  alias Dian.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Dian Bot Admin", "dianbot@tunkshif.one"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(email, url) do
    deliver(email, "Confirmation instructions", """
    ====================================================

    Hi #{email},

    你的注册激活链接是：

    #{url}

    请在一天内完成注册，如果你没有申请注册过请忽略本条邮件。

    =====================================================
    """)
  end
end
