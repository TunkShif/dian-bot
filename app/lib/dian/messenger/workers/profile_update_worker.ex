defmodule Dian.Messenger.ProfileUpdateWorker do
  use Oban.Worker, max_attempts: 3

  alias Dian.Messenger

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    Messenger.update_groups()
    :ok
  end
end
